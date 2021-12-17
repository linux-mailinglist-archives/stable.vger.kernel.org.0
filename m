Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C90478B6A
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhLQMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbhLQMdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:33:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1FAC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 04:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B13F62127
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DE1C36AE1;
        Fri, 17 Dec 2021 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639744403;
        bh=WTiNZ7kvnj7WOUqL+vKU7A3RTj5Bx4PW4j6COxO3HTU=;
        h=Subject:To:Cc:From:Date:From;
        b=kCAPjHq67R2PtkP3cbB44RqQIHLvlqv1AB9LiHpJER20Z+CDUXFj1bv2DFaFY71v5
         YcnreA/TKHHeWwo5dU2EgEF5Dc1nFEzhe17TdSGYombaVVxhBFwMLAi36MvhnI51Qz
         xom+md2ER1tTDTYygmrCNyh1d1/RWa2yQyQHUvD4=
Subject: FAILED: patch "[PATCH] firmware: arm_scpi: Fix string overflow in SCPI genpd driver" failed to apply to 4.19-stable tree
To:     sudeep.holla@arm.com, arnd@arndb.de, cristian.marussi@arm.com,
        pedbap.g@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 13:33:13 +0100
Message-ID: <1639744393141200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 865ed67ab955428b9aa771d8b4f1e4fb7fd08945 Mon Sep 17 00:00:00 2001
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Thu, 9 Dec 2021 12:04:56 +0000
Subject: [PATCH] firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Without the bound checks for scpi_pd->name, it could result in the buffer
overflow when copying the SCPI device name from the corresponding device
tree node as the name string is set at maximum size of 30.

Let us fix it by using devm_kasprintf so that the string buffer is
allocated dynamically.

Fixes: 8bec4337ad40 ("firmware: scpi: add device power domain support using genpd")
Reported-by: Pedro Batista <pedbap.g@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Cc: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20211209120456.696879-1-sudeep.holla@arm.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/firmware/scpi_pm_domain.c b/drivers/firmware/scpi_pm_domain.c
index 51201600d789..800673910b51 100644
--- a/drivers/firmware/scpi_pm_domain.c
+++ b/drivers/firmware/scpi_pm_domain.c
@@ -16,7 +16,6 @@ struct scpi_pm_domain {
 	struct generic_pm_domain genpd;
 	struct scpi_ops *ops;
 	u32 domain;
-	char name[30];
 };
 
 /*
@@ -110,8 +109,13 @@ static int scpi_pm_domain_probe(struct platform_device *pdev)
 
 		scpi_pd->domain = i;
 		scpi_pd->ops = scpi_ops;
-		sprintf(scpi_pd->name, "%pOFn.%d", np, i);
-		scpi_pd->genpd.name = scpi_pd->name;
+		scpi_pd->genpd.name = devm_kasprintf(dev, GFP_KERNEL,
+						     "%pOFn.%d", np, i);
+		if (!scpi_pd->genpd.name) {
+			dev_err(dev, "Failed to allocate genpd name:%pOFn.%d\n",
+				np, i);
+			continue;
+		}
 		scpi_pd->genpd.power_off = scpi_pd_power_off;
 		scpi_pd->genpd.power_on = scpi_pd_power_on;
 

