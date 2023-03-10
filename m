Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596AA6B4556
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjCJOdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjCJOcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167DFF82A4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A07618C9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C82C433D2;
        Fri, 10 Mar 2023 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458725;
        bh=3PvgcoIZwab3V+vowqhc/ZAxBoE0Ae99JaLFrKE3m0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocy6sVs8fc3S1ERWtTJ91sax4AqGjtJNbSqhccMXB1ZMXO78+q/ka8V4+nrkKgoA/
         1DgydWFXTKG/6/XOVUEJZaCBd3I8LqTZsuJ3DrH8K0rwsLj/2YpuD2ZQYeo7qvffAe
         Pp9y3xcuoBg7fl8ZiYcOFbsFDEqKX8A6nL30qI5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/357] usb: gadget: udc: Avoid tasklet passing a global
Date:   Fri, 10 Mar 2023 14:36:12 +0100
Message-Id: <20230310133737.649030421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f9dc3713df1229aa8168169e9cf1010fbac68de5 ]

There's no reason for the tasklet callback to set an argument since it
always uses a global. Instead, use the global directly, in preparation
for converting the tasklet subsystem to modern callback conventions.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 1fdeb8b9f29d ("wifi: iwl3945: Add missing check for create_singlethread_workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/snps_udc_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index 3fcded31405a7..afdd28f332ced 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -96,9 +96,7 @@ static int stop_pollstall_timer;
 static DECLARE_COMPLETION(on_pollstall_exit);
 
 /* tasklet for usb disconnect */
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
-		(unsigned long) &udc);
-
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
 
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
@@ -1661,7 +1659,7 @@ static void usb_disconnect(struct udc *dev)
 /* Tasklet for disconnect to be outside of interrupt context */
 static void udc_tasklet_disconnect(unsigned long par)
 {
-	struct udc *dev = (struct udc *)(*((struct udc **) par));
+	struct udc *dev = udc;
 	u32 tmp;
 
 	DBG(dev, "Tasklet disconnect\n");
-- 
2.39.2



