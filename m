Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F8D59BBC3
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiHVIiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiHVIiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CBE2CDED
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B24C661059
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23F9C433D6;
        Mon, 22 Aug 2022 08:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661157479;
        bh=HWDPxtXkxVbMRnRZL4/k/N3+EF+ZWDuR6SIVdW7FrRA=;
        h=Subject:To:Cc:From:Date:From;
        b=xYkvfwvpxsFJ0ZC1SqzXgb66sRt+s0QX2iNHNYz/WJzUEhESwjE3Mihn5N4PAKpbE
         GYo4ZDWjYo1hA3uM2mVfluCWAJoq0RiWIGxztnA/LCFLE5ffiAO1lKjov7zmkWPW/r
         vmR9GKmvfYWvSqX+tlygyyj2FekLoDMINo+LzCoA=
Subject: FAILED: patch "[PATCH] virtio_net: fix memory leak inside XPD_TX with mergeable" failed to apply to 5.4-stable tree
To:     xuanzhuo@linux.alibaba.com, davem@davemloft.net,
        jasowang@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:37:56 +0200
Message-ID: <1661157476120157@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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

