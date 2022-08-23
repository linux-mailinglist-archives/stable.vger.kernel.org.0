Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4759DD04
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359308AbiHWMHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359724AbiHWMGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:06:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF721E;
        Tue, 23 Aug 2022 02:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F938B81C89;
        Tue, 23 Aug 2022 09:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A934FC433D6;
        Tue, 23 Aug 2022 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247460;
        bh=u4A5WIwiymsMQc9oxnnVUUrLYCHeBa/9DFyqkrzssfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2Pu4XX5kh0QsM/s2ecGBDo/L0umSxg+jGSeqI4syKcOftZPBzpRlG7RMvRUjBcWY
         qk7KXdpS2tSYEEuulU1Cd2ZfN2ekTxqVvzCBLiz3gGqhTParV1uDY2WdXSe4RKzjcB
         LvR9PDuW0B00HoUAVgLjlweAFBOL6BLLF+56y3UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 036/158] virtio_net: fix memory leak inside XPD_TX with mergeable
Date:   Tue, 23 Aug 2022 10:26:08 +0200
Message-Id: <20220823080047.524501428@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

commit 7a542bee27c6a57e45c33cbbdc963325fd6493af upstream.

When we call xdp_convert_buff_to_frame() to get xdpf, if it returns
NULL, we should check if xdp_page was allocated by xdp_linearize_page().
If it is newly allocated, it should be freed here alone. Just like any
other "goto err_xdp".

Fixes: 44fa2dbd4759 ("xdp: transition into using xdp_frame for ndo_xdp_xmit")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -968,8 +968,11 @@ static struct sk_buff *receive_mergeable
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
 			if (unlikely(err < 0)) {
 				trace_xdp_exception(vi->dev, xdp_prog, act);


