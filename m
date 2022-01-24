Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284ED499936
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454275AbiAXVcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:32:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449126AbiAXVO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D539061320;
        Mon, 24 Jan 2022 21:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3B3C340E5;
        Mon, 24 Jan 2022 21:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058896;
        bh=g6pSpn2i0X05d9/e/pvWbJQ995pdOEPCyDaWB64n2Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8TfzFupAeMFv+oOIcOMkIgwCyIAZtoxIxpTUMh3Q9UZLkupdfvTAh9MqnJz/Wrvf
         gisa2/zIcZLd0V3XN8r/K2sfEY0ZKQy3uk/VeMVCl98xpvLLngAfpGLb4kF91mVsGP
         992ygy/t9dnIQKygJgcsxWy//EFpUZ7Xz9tAFScI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0436/1039] pcmcia: fix setting of kthread task states
Date:   Mon, 24 Jan 2022 19:37:05 +0100
Message-Id: <20220124184139.955395323@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

[ Upstream commit fbb3485f1f931102d8ba606f1c28123f5b48afa3 ]

We need to set TASK_INTERRUPTIBLE before calling kthread_should_stop().
Otherwise, kthread_stop() might see that the pccardd thread is still
in TASK_RUNNING state and fail to wake it up.

Additionally, we only need to set the state back to TASK_RUNNING if
kthread_should_stop() breaks the loop.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: d3046ba809ce ("pcmcia: fix a boot time warning in pcmcia cs code")
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/cs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index e211e2619680c..f70197154a362 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -666,18 +666,16 @@ static int pccardd(void *__skt)
 		if (events || sysfs_events)
 			continue;
 
+		set_current_state(TASK_INTERRUPTIBLE);
 		if (kthread_should_stop())
 			break;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		schedule();
 
-		/* make sure we are running */
-		__set_current_state(TASK_RUNNING);
-
 		try_to_freeze();
 	}
+	/* make sure we are running before we exit */
+	__set_current_state(TASK_RUNNING);
 
 	/* shut down socket, if a device is still present */
 	if (skt->state & SOCKET_PRESENT) {
-- 
2.34.1



