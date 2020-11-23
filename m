Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4D12C06D7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbgKWMe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbgKWMey (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA3C2076E;
        Mon, 23 Nov 2020 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134892;
        bh=xgV2vw+bfK/N9sJ8IzwchGJ6z4ouI/jLgeEad8D0/KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEwmP40uD+RrUmJgZJiyC2zj2sx9CEGVTYsIVTDSJZMoxqfWAvMLx+Q8P8JdfBdJR
         7KmOk2rvgS2TSm/Wkehu8dprdHa/BFvfZS+gOVfFdSHQp5cg+hOYtI1wJ2ztwRT607
         x/6YZKrMBwnvWon6jE0e5LmcLwYAlzAB8o91jqDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 022/158] net/tls: fix corrupted data in recvmsg
Date:   Mon, 23 Nov 2020 13:20:50 +0100
Message-Id: <20201123121821.004516205@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 3fe16edf6767decd640fa2654308bc64f8d656dc ]

If tcp socket has more data than Encrypted Handshake Message then
tls_sw_recvmsg will try to decrypt next record instead of returning
full control message to userspace as mentioned in comment. The next
message - usually Application Data - gets corrupted because it uses
zero copy for decryption that's why the data is not stored in skb
for next iteration. Revert check to not decrypt next record if
current is not Application Data.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Link: https://lore.kernel.org/r/1605413760-21153-1-git-send-email-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1907,7 +1907,7 @@ pick_next_record:
 			 * another message type
 			 */
 			msg->msg_flags |= MSG_EOR;
-			if (ctx->control != TLS_RECORD_TYPE_DATA)
+			if (control != TLS_RECORD_TYPE_DATA)
 				goto recv_end;
 		} else {
 			break;


