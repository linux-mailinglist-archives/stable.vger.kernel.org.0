Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D13A60E3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhFNKkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhFNKhG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5206140D;
        Mon, 14 Jun 2021 10:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666798;
        bh=7P8EsJh8qLdqkjWHvgkVR97WWApO6HK8ZHQQN7jUtY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm9rwOGrr/JKKfJH8VIKGHkDZdjskIOvc2fMDlgU67fF+BFYJsAOSQgDBFKHciUb2
         JeL3u0ba9wmjTwIoRCixAOZjEx/DMXhTNYzOEd88wFjZi7jmSw8VMQusjGd50lgbBA
         d4XDlY8cengRI8dMTEh7nhGxOzZMeuo5SkqDDW8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <linyyuan@codeaurora.com>
Subject: [PATCH 4.14 34/49] usb: gadget: eem: fix wrong eem header operation
Date:   Mon, 14 Jun 2021 12:27:27 +0200
Message-Id: <20210614102642.991598495@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
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
@@ -502,7 +502,7 @@ static int eem_unwrap(struct gether *por
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (unlikely(!skb2)) {
 				DBG(cdev, "unable to unframe EEM packet\n");
-				continue;
+				goto next;
 			}
 			skb_trim(skb2, len - ETH_FCS_LEN);
 
@@ -513,7 +513,7 @@ static int eem_unwrap(struct gether *por
 			if (unlikely(!skb3)) {
 				DBG(cdev, "unable to realign EEM packet\n");
 				dev_kfree_skb_any(skb2);
-				continue;
+				goto next;
 			}
 			dev_kfree_skb_any(skb2);
 			skb_queue_tail(list, skb3);


