Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8554F3E7FA9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhHJRlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235717AbhHJRkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51AA0611CA;
        Tue, 10 Aug 2021 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617067;
        bh=d/aABDZJ/OAKgVrEeVRugrVYFHZ/UYa4dGR04RG59SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7MEeMSMs2h6rRawBykydtcVBOKUeG1yuLbMKphn1Krm25qyPOboTyYeo1nSRqSf/
         r9Z8Ki0bV5iukWW3jvIzo4OeE1CnYAMatkdTcnQMnEZsyheNs5zd5XjZG5WXipswxB
         eg+ie7Fva2lcrjytHZ8+JxnxcYKlLwrH03lMz7pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/135] bus: ti-sysc: Fix gpt12 system timer issue with reserved status
Date:   Tue, 10 Aug 2021 19:28:57 +0200
Message-Id: <20210810172955.789238213@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 3ff340e24c9dd5cff9fc07d67914c5adf67f80d6 ]

Jarkko Nikula <jarkko.nikula@bitmer.com> reported that Beagleboard
revision c2 stopped booting. Jarkko bisected the issue down to
commit 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend
and resume for am3 and am4").

Let's fix the issue by tagging system timers as reserved rather than
ignoring them. And let's not probe any interconnect target module child
devices for reserved modules.

This allows PM runtime to keep track of clocks and clockdomains for
the interconnect target module, and prevent the system timer from idling
as we already have SYSC_QUIRK_NO_IDLE and SYSC_QUIRK_NO_IDLE_ON_INIT
flags set for system timers.

Fixes: 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend and resume for am3 and am4")
Reported-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Tested-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 818dc7f54f03..d3d31123a0a4 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -100,6 +100,7 @@ static const char * const clock_names[SYSC_MAX_CLOCKS] = {
  * @cookie: data used by legacy platform callbacks
  * @name: name if available
  * @revision: interconnect target module revision
+ * @reserved: target module is reserved and already in use
  * @enabled: sysc runtime enabled status
  * @needs_resume: runtime resume needed on resume from suspend
  * @child_needs_resume: runtime resume needed for child on resume from suspend
@@ -130,6 +131,7 @@ struct sysc {
 	struct ti_sysc_cookie cookie;
 	const char *name;
 	u32 revision;
+	unsigned int reserved:1;
 	unsigned int enabled:1;
 	unsigned int needs_resume:1;
 	unsigned int child_needs_resume:1;
@@ -3057,8 +3059,8 @@ static int sysc_probe(struct platform_device *pdev)
 		return error;
 
 	error = sysc_check_active_timer(ddata);
-	if (error)
-		return error;
+	if (error == -EBUSY)
+		ddata->reserved = true;
 
 	error = sysc_get_clocks(ddata);
 	if (error)
@@ -3094,11 +3096,15 @@ static int sysc_probe(struct platform_device *pdev)
 	sysc_show_registers(ddata);
 
 	ddata->dev->type = &sysc_device_type;
-	error = of_platform_populate(ddata->dev->of_node, sysc_match_table,
-				     pdata ? pdata->auxdata : NULL,
-				     ddata->dev);
-	if (error)
-		goto err;
+
+	if (!ddata->reserved) {
+		error = of_platform_populate(ddata->dev->of_node,
+					     sysc_match_table,
+					     pdata ? pdata->auxdata : NULL,
+					     ddata->dev);
+		if (error)
+			goto err;
+	}
 
 	INIT_DELAYED_WORK(&ddata->idle_work, ti_sysc_idle);
 
-- 
2.30.2



