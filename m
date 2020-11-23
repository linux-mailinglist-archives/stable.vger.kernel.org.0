Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50A22C0A2C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbgKWNRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732911AbgKWMmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6592065E;
        Mon, 23 Nov 2020 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135344;
        bh=bOAFKfOaeoeA2qAaBIP8Jdk1qhz1J3msR6k6vv4kSZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqwiO4dfUIKoS5di13uzbtEdG1eCxLJReM8KRQug2pG8yxyFgjxSagmAjWaQyLNIw
         9rznrWMfz1zTilUTrIbXQ0mUsMdbsas6p7ui9ThJeyKC/3YchwYejfXIVHDoimc2F2
         RIZRMoLbxFNs24z9cyDikNAOczgdvWqW1tr/tJrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 034/252] net/tls: fix corrupted data in recvmsg
Date:   Mon, 23 Nov 2020 13:19:44 +0100
Message-Id: <20201123121837.234443583@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
@@ -1913,7 +1913,7 @@ pick_next_record:
 			 * another message type
 			 */
 			msg->msg_flags |= MSG_EOR;
-			if (ctx->control != TLS_RECORD_TYPE_DATA)
+			if (control != TLS_RECORD_TYPE_DATA)
 				goto recv_end;
 		} else {
 			break;


