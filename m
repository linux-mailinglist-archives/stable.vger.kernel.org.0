Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC243653C81
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 08:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiLVH3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 02:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLVH3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 02:29:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB31BC30
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 23:29:18 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n197-20020a25d6ce000000b00702558fba96so1106051ybg.0
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 23:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YDBQOU+0luLi27shrHHDO2SRv4ai6dz5pCa52is39dQ=;
        b=iyErmQImVKKNNTRt+pdj6Ntw0fQgB9SlSnTHvhEXKX9A1ANKW81xBXTTwAdp7y2JDx
         u6bWXDVQuSRQjViyREmniY3etXM4sCrTuCKcLWSBbs2hRUH4CNCuWooUyMkW3gVccYEt
         7K4yX2KFPokD1wGq7s9sSWJNSHYUbdlsiDfEjILmWobBEJnLEE5JkKpwvVAd93q665gT
         cNuCR8oY7J1lWy4ntIfDwlL/8p6TJ+dQMm7RC/pX4Z5nCOyFeagZE49TF4JrNdLLW0s6
         rSYu7mEakG3h5ZTcpaFegNCEla3Mku56Zw59AYRALgXhl1zfa9ZmaGU6XRoVh96alT4o
         llIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YDBQOU+0luLi27shrHHDO2SRv4ai6dz5pCa52is39dQ=;
        b=sZZePCKiGYkzlDhq23IBh+X0a/3KgG7zGEzDWFqSpq+wutb29E4e74lsDw47UgOmzB
         QhGIkY3IRu1VybfPDomvD1kTrHSMVUDy979XqMVTZ+Bhk4CdRCBScmGoHob+q+5/bZTS
         K11HZxU/4Wdlv0fmGz4JjN8a+NhzjUBcHxOoh0YAyK3xkjXQPGSh6EqFweRvmJKuInbI
         WxAFlgsWWOX8vzGUqQPpRKtA735ASZY0uf9/58OsZBGJl6PakVjWfjOtaAdPU3PGNmlB
         u54Y1y0HH2IJA7e03FkCMnYmKG62CQTF+HmcioKfekrx+H8IjeJd5k2Rc8dmZyJQpZOc
         XXIg==
X-Gm-Message-State: AFqh2kr35Mdj6SJfTn6IfE+GuxOtoDm4HOYUKTP/VeETvbY+P63ZnIbS
        6rc5mk3YD72hcN4TOSDEonFGEhduCbA=
X-Google-Smtp-Source: AMrXdXsw3K5e0ejM3+wRydXNF+NfW/0OfhSvRepRxGDF2lEIac10qPBfPK6x49VmTKZSNK9p4LXq5kKUgok=
X-Received: from hhhuuu.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:c80])
 (user=hhhuuu job=sendgmr) by 2002:a0d:ca93:0:b0:44d:26dc:2fc7 with SMTP id
 m141-20020a0dca93000000b0044d26dc2fc7mr359175ywd.333.1671694158099; Wed, 21
 Dec 2022 23:29:18 -0800 (PST)
Date:   Thu, 22 Dec 2022 07:29:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222072912.1843384-1-hhhuuu@google.com>
Subject: [PATCH v2] usb: xhci: Check endpoint is valid before dereferencing it
From:   Jimmy Hu <hhhuuu@google.com>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jimmy Hu <hhhuuu@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the host controller is not responding, all URBs queued to all
endpoints need to be killed. This can cause a kernel panic if we
dereference an invalid endpoint.

Fix this by using xhci_get_virt_ep() helper to find the endpoint and
checking if the endpoint is valid before dereferencing it.

[233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
[233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8

[233311.853964] pc : xhci_hc_died+0x10c/0x270
[233311.853971] lr : xhci_hc_died+0x1ac/0x270

[233311.854077] Call trace:
[233311.854085]  xhci_hc_died+0x10c/0x270
[233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
[233311.854105]  call_timer_fn+0x50/0x2d4
[233311.854112]  expire_timers+0xac/0x2e4
[233311.854118]  run_timer_softirq+0x300/0xabc
[233311.854127]  __do_softirq+0x148/0x528
[233311.854135]  irq_exit+0x194/0x1a8
[233311.854143]  __handle_domain_irq+0x164/0x1d0
[233311.854149]  gic_handle_irq.22273+0x10c/0x188
[233311.854156]  el1_irq+0xfc/0x1a8
[233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
[233311.854185]  cpuidle_enter_state+0x1f0/0x764
[233311.854194]  do_idle+0x594/0x6ac
[233311.854201]  cpu_startup_entry+0x7c/0x80
[233311.854209]  secondary_start_kernel+0x170/0x198

Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Hu <hhhuuu@google.com>
---
 drivers/usb/host/xhci-ring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ddc30037f9ce..f5b0e1ce22af 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep;
 	struct xhci_ring *ring;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	if ((ep->ep_state & EP_HAS_STREAMS) ||
 			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
 		int stream_id;
-- 
2.39.0.314.g84b9a713c41-goog

