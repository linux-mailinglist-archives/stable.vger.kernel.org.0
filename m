Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7588D4B4923
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345691AbiBNKOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:14:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345765AbiBNKNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF21B60AA3;
        Mon, 14 Feb 2022 01:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A6AB60F25;
        Mon, 14 Feb 2022 09:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2FFC340E9;
        Mon, 14 Feb 2022 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832314;
        bh=7dywxaiY+M967eUBC6Mz+LePl1QSR7NFa4x8qm8PoNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNYQhdtTLLeUBQuzOGPF0RNRyHWuEU78g0Qj0ddKawGcda6r3UMc2Jom41pVc0nA0
         TNtwD/7ix8T9DMrbe/0AGajW0asuhFSwwDALI9rHklXNUpG7ZeD+EMfr5yCAEzT+qM
         goIItSVgzUqFPrvL0d1eGUaOOxKIxCsBacU0qzn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH 5.15 148/172] usb: raw-gadget: fix handling of dual-direction-capable endpoints
Date:   Mon, 14 Feb 2022 10:26:46 +0100
Message-Id: <20220214092511.495970058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 292d2c82b105d92082c2120a44a58de9767e44f1 upstream.

Under dummy_hcd, every available endpoint is *either* IN or OUT capable.
But with some real hardware, there are endpoints that support both IN and
OUT. In particular, the PLX 2380 has four available endpoints that each
support both IN and OUT.

raw-gadget currently gets confused and thinks that any endpoint that is
usable as an IN endpoint can never be used as an OUT endpoint.

Fix it by looking at the direction in the configured endpoint descriptor
instead of looking at the hardware capabilities.

With this change, I can use the PLX 2380 with raw-gadget.

Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Cc: stable <stable@vger.kernel.org>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20220126205214.2149936-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -1004,7 +1004,7 @@ static int raw_process_ep_io(struct raw_
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	if ((in && !ep->ep->caps.dir_in) || (!in && ep->ep->caps.dir_in)) {
+	if (in != usb_endpoint_dir_in(ep->ep->desc)) {
 		dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
 		ret = -EINVAL;
 		goto out_unlock;


