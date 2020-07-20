Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8D2268AA
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbgGTQJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387539AbgGTQJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEC62064B;
        Mon, 20 Jul 2020 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261375;
        bh=+RogU8qMklfNJsyUiqiWxEMpF0Ok1b40BT273JMLjwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08CELHQUXl7GGsxkhWNqQpgsvMbq0/9TlehewhD7YDyJIdJ7j5BDAA0MHq+H/hjKN
         oOy1TDZVBtptU+25tqmsBvXHo1b/0H3em8UCLtuVHjv5f7BSriZLD2ERR/Op2Dep6Z
         Ac1E/0VV1YnNRm9xdx/+j0ZjEsSre4qf5EdWYBlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 093/244] bus: ti-sysc: Do not disable on suspend for no-idle
Date:   Mon, 20 Jul 2020 17:36:04 +0200
Message-Id: <20200720152830.262287752@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a55de412228cc5a2b4bf8d2a09849898102633e2 ]

If we have "ti,no-idle" specified for a module we must not disable
the the module on suspend to keep things backwards compatible.

Fixes: 386cb76681ca ("bus: ti-sysc: Handle missed no-idle property in addition to no-idle-on-init")
Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index a3a279f30177c..3b0417a014946 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1278,7 +1278,8 @@ static int __maybe_unused sysc_noirq_suspend(struct device *dev)
 
 	ddata = dev_get_drvdata(dev);
 
-	if (ddata->cfg.quirks & SYSC_QUIRK_LEGACY_IDLE)
+	if (ddata->cfg.quirks &
+	    (SYSC_QUIRK_LEGACY_IDLE | SYSC_QUIRK_NO_IDLE))
 		return 0;
 
 	return pm_runtime_force_suspend(dev);
@@ -1290,7 +1291,8 @@ static int __maybe_unused sysc_noirq_resume(struct device *dev)
 
 	ddata = dev_get_drvdata(dev);
 
-	if (ddata->cfg.quirks & SYSC_QUIRK_LEGACY_IDLE)
+	if (ddata->cfg.quirks &
+	    (SYSC_QUIRK_LEGACY_IDLE | SYSC_QUIRK_NO_IDLE))
 		return 0;
 
 	return pm_runtime_force_resume(dev);
-- 
2.25.1



