Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAD3A6470
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhFNLZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhFNLWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E07561997;
        Mon, 14 Jun 2021 10:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667954;
        bh=GXkKJAaY1quZ0z2weVFfgkenet1vk6/lym2c5MlOqU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIqxhsWbpI7UMhtCl2p382dAoUd3YHoTP26559o4KMGJMtAmpxafwq2mXAhColUvW
         P3v6g+pJJPkO9+h2AbyQc5Av+PtRuBz6+8GLkgdQM/iKA3CahvSrIpKnVLg67gVwCS
         eDvEBd6x47ymPZnuqetnhSZMhdiyaO1Sq1GvKH58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <linyyuan@codeaurora.com>
Subject: [PATCH 5.12 106/173] usb: gadget: eem: fix wrong eem header operation
Date:   Mon, 14 Jun 2021 12:27:18 +0200
Message-Id: <20210614102701.695402379@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <linyyuan@codeaurora.com>

commit 305f670846a31a261462577dd0b967c4fa796871 upstream.

when skb_clone() or skb_copy_expand() fail,
it should pull skb with lengh indicated by header,
or not it will read network data and check it as header.

Cc: <stable@vger.kernel.org>
Signed-off-by: Linyu Yuan <linyyuan@codeaurora.com>
Link: https://lore.kernel.org/r/20210608233547.3767-1-linyyuan@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_eem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -495,7 +495,7 @@ static int eem_unwrap(struct gether *por
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (unlikely(!skb2)) {
 				DBG(cdev, "unable to unframe EEM packet\n");
-				continue;
+				goto next;
 			}
 			skb_trim(skb2, len - ETH_FCS_LEN);
 
@@ -505,7 +505,7 @@ static int eem_unwrap(struct gether *por
 						GFP_ATOMIC);
 			if (unlikely(!skb3)) {
 				dev_kfree_skb_any(skb2);
-				continue;
+				goto next;
 			}
 			dev_kfree_skb_any(skb2);
 			skb_queue_tail(list, skb3);


