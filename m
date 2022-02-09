Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19124AE78D
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 04:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244675AbiBIDD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 22:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiBICwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 21:52:47 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F17C0613CC;
        Tue,  8 Feb 2022 18:52:47 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so3792263pjl.2;
        Tue, 08 Feb 2022 18:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2whpxl+iWHDZgmDT6i5bR2ewH2KRNqLgWWFYpzHxiLY=;
        b=dDW0LZ7dNOnFLGGCp0CcwhMtoHjLcJvd3dOUCh6PqTWY4vDWMz1UvdZNN2iDb38cyE
         KwDnG8zRHUI9812Fu4fXDo/H2NVXQowotVvnIjgPeRC9UeQM04otNeSj3fQhuUwUMlt1
         fH6k2QIqg+Q53spcCa+gTlrdk9CS9+7GvDQlAMr4CfkTeySC4o9nOIi6WMgxBo1z4+yk
         J2L6URa37qwD9pKz8IeXHL0WUDxuWMSfxgnN/2G427QdBhAGXiBi5hWWxhH2L5MQNldi
         ME0bb3BvP2lT09b5ir6raQ9bDxoGGYV5tQg1SwGskEIf+8cC76k8R7YEnk4J6ZehSa1R
         wYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2whpxl+iWHDZgmDT6i5bR2ewH2KRNqLgWWFYpzHxiLY=;
        b=vvIs8eqVbjwpTw3uhgGiJOew7hUoyg2SEoCuZPmPFh27XDiPmvxB+WUXOMSv/m/FOr
         fxdjXeiztrqI41aSGVZEdz2KfGXceQlWz1m338IQiXw14SSXxG5C29dxEVO5bCrE0qR7
         jo8CTCLu8HDrqDlrpS2zrad2IPihNU5fpqXGBbJf2kf1YaKoMwvV0uP17JhzLm+ygv5h
         UTudZ0PzlIibwwX+e2vsi4GVhx68CVsx4OhYyqddE3VfiMOj1NEozv62WcmaJiU2Ucw6
         LjFKlVK64TeIJ4B4Uo/CPsj9J1Xv6tvZKeBe8Ei1rCth9V1AXYmao8nKMB1NiUgiMShM
         uFNQ==
X-Gm-Message-State: AOAM532SWV56bqml1oZBg4EBESfNaik457+6bPPixLDNoUm5e/zWVnuN
        j/z1o7RN4YGpMSZTf/eE6Gw/JjmA2dSgr9vvh7s=
X-Google-Smtp-Source: ABdhPJzQHsBfd4wlS1+EyrLw3I0I8GL3iXcN+u4lP4qQem2tMb0q6+WSy0DY+8e/CKm4fmL3rOWc1g==
X-Received: by 2002:a17:902:ea06:: with SMTP id s6mr92442plg.163.1644375166589;
        Tue, 08 Feb 2022 18:52:46 -0800 (PST)
Received: from jason-ThinkPad-T14-Gen-1.lan ([66.187.5.142])
        by smtp.gmail.com with ESMTPSA id q2sm4017176pjj.32.2022.02.08.18.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 18:52:46 -0800 (PST)
From:   Hongyu Xie <xy521521@gmail.com>
To:     gregkh@linuxfoundation.org, mathias.nyman@intel.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH -next v2] xhci: fix two places when dealing with return value of function xhci_check_args
Date:   Wed,  9 Feb 2022 10:52:34 +0800
Message-Id: <20220209025234.25230-1-xy521521@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongyu Xie <xiehongyu1@kylinos.cn>

xhci_check_args returns 4 types of value, -ENODEV, -EINVAL, 1 and 0.
xhci_urb_enqueue and xhci_check_streams_endpoint return -EINVAL if
the return value of xhci_check_args <= 0.
This will cause a problem.
For example, r8152_submit_rx calling usb_submit_urb in
drivers/net/usb/r8152.c.
r8152_submit_rx will never get -ENODEV after submiting an urb
when xHC is halted,
because xhci_urb_enqueue returns -EINVAL in the very beginning.

Fixes: 203a86613fb3 ("xhci: Avoid NULL pointer deref when host dies.")
Cc: stable@vger.kernel.org
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
---

v2: keep return value to -EINVAL for roothub urbs

 drivers/usb/host/xhci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dc357cabb265..948546b98af0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1604,9 +1604,12 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 	struct urb_priv	*urb_priv;
 	int num_tds;
 
-	if (!urb || xhci_check_args(hcd, urb->dev, urb->ep,
-					true, true, __func__) <= 0)
+	if (!urb)
 		return -EINVAL;
+	ret = xhci_check_args(hcd, urb->dev, urb->ep,
+					true, true, __func__);
+	if (ret <= 0)
+		return ret ? ret : -EINVAL;
 
 	slot_id = urb->dev->slot_id;
 	ep_index = xhci_get_endpoint_index(&urb->ep->desc);
@@ -3323,7 +3326,7 @@ static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
 		return -EINVAL;
 	ret = xhci_check_args(xhci_to_hcd(xhci), udev, ep, 1, true, __func__);
 	if (ret <= 0)
-		return -EINVAL;
+		return ret ? ret : -EINVAL;
 	if (usb_ss_max_streams(&ep->ss_ep_comp) == 0) {
 		xhci_warn(xhci, "WARN: SuperSpeed Endpoint Companion"
 				" descriptor for ep 0x%x does not support streams\n",
-- 
2.25.1

