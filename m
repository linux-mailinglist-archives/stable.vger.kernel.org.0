Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B6A59BBC4
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiHVIiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiHVIiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:38:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E632CDE8
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22973B80EA1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE40C433D6;
        Mon, 22 Aug 2022 08:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661157487;
        bh=HdiQ7TpCoLWOH+9PnsQm0gmDot8qOeCPIDO3CVHLmTU=;
        h=Subject:To:Cc:From:Date:From;
        b=WglQcmtcOP+DlJfswHKU+8vMtEcMJbA004L3+A33gJ1fVnUxwlnSacnUdOt5SPDJu
         9j7ZfOTaJTiqxSroSGXpDYb3ObhI//mAEw+89kTEplPlIsi3AqwNRakuuaZaBIKfUV
         8ufxqOLKrAFRaPVGJT4eCbRcnCPdOOwJiLaXBVg4=
Subject: FAILED: patch "[PATCH] virtio_net: fix memory leak inside XPD_TX with mergeable" failed to apply to 4.19-stable tree
To:     xuanzhuo@linux.alibaba.com, davem@davemloft.net,
        jasowang@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:37:56 +0200
Message-ID: <166115747658155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 7a542bee27c6a57e45c33cbbdc963325fd6493af Mon Sep 17 00:00:00 2001
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Thu, 4 Aug 2022 14:32:48 +0800
Subject: [PATCH] virtio_net: fix memory leak inside XPD_TX with mergeable

When we call xdp_convert_buff_to_frame() to get xdpf, if it returns
NULL, we should check if xdp_page was allocated by xdp_linearize_page().
If it is newly allocated, it should be freed here alone. Just like any
other "goto err_xdp".

Fixes: 44fa2dbd4759 ("xdp: transition into using xdp_frame for ndo_xdp_xmit")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec8e1b3108c3..3b3eebad3977 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1057,8 +1057,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_TX:
 			stats->xdp_tx++;
 			xdpf = xdp_convert_buff_to_frame(&xdp);
-			if (unlikely(!xdpf))
+			if (unlikely(!xdpf)) {
+				if (unlikely(xdp_page != page))
+					put_page(xdp_page);
 				goto err_xdp;
+			}
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
 			if (unlikely(!err)) {
 				xdp_return_frame_rx_napi(xdpf);

