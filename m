Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184EB4CF836
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiCGJwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239289AbiCGJt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6A49255;
        Mon,  7 Mar 2022 01:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2536B6116E;
        Mon,  7 Mar 2022 09:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E19AC340E9;
        Mon,  7 Mar 2022 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646183;
        bh=eilNXL7FYByQZsmEqMoxFr7L+I0SJTK7SW/o3Pnue4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKMuzSVW1nYYLyFzjaFbZ7XzpXBrf1kGLMnaBNv1hXBeqyKaCS0hvLzruhxCGz2JB
         LdNB3EUX+EWUZbiV+Q2YMkyMBe8GWdfVdplJMkOdBFs6fhPKAjsXk3tplGQWOafpcr
         AsLYfrjKfV8/Jituk3FN9QvYdL2yiP066jn0cACU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lena wang <lena.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 159/262] net: fix up skbs delta_truesize in UDP GRO frag_list
Date:   Mon,  7 Mar 2022 10:18:23 +0100
Message-Id: <20220307091706.921361675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lena wang <lena.wang@mediatek.com>

commit 224102de2ff105a2c05695e66a08f4b5b6b2d19c upstream.

The truesize for a UDP GRO packet is added by main skb and skbs in main
skb's frag_list:
skb_gro_receive_list
        p->truesize += skb->truesize;

The commit 53475c5dd856 ("net: fix use-after-free when UDP GRO with
shared fraglist") introduced a truesize increase for frag_list skbs.
When uncloning skb, it will call pskb_expand_head and trusesize for
frag_list skbs may increase. This can occur when allocators uses
__netdev_alloc_skb and not jump into __alloc_skb. This flow does not
use ksize(len) to calculate truesize while pskb_expand_head uses.
skb_segment_list
err = skb_unclone(nskb, GFP_ATOMIC);
pskb_expand_head
        if (!skb->sk || skb->destructor == sock_edemux)
                skb->truesize += size - osize;

If we uses increased truesize adding as delta_truesize, it will be
larger than before and even larger than previous total truesize value
if skbs in frag_list are abundant. The main skb truesize will become
smaller and even a minus value or a huge value for an unsigned int
parameter. Then the following memory check will drop this abnormal skb.

To avoid this error we should use the original truesize to segment the
main skb.

Fixes: 53475c5dd856 ("net: fix use-after-free when UDP GRO with shared fraglist")
Signed-off-by: lena wang <lena.wang@mediatek.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/1646133431-8948-1-git-send-email-lena.wang@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3853,6 +3853,7 @@ struct sk_buff *skb_segment_list(struct
 		list_skb = list_skb->next;
 
 		err = 0;
+		delta_truesize += nskb->truesize;
 		if (skb_shared(nskb)) {
 			tmp = skb_clone(nskb, GFP_ATOMIC);
 			if (tmp) {
@@ -3877,7 +3878,6 @@ struct sk_buff *skb_segment_list(struct
 		tail = nskb;
 
 		delta_len += nskb->len;
-		delta_truesize += nskb->truesize;
 
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 


