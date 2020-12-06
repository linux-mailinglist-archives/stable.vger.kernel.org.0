Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E722D040D
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgLFLmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbgLFLmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:42:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 21/39] inet_ecn: Fix endianness of checksum update when setting ECT(1)
Date:   Sun,  6 Dec 2020 12:17:25 +0100
Message-Id: <20201206111555.693217763@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Toke Høiland-Jørgensen" <toke@redhat.com>

[ Upstream commit 2867e1eac61016f59b3d730e3f7aa488e186e917 ]

When adding support for propagating ECT(1) marking in IP headers it seems I
suffered from endianness-confusion in the checksum update calculation: In
fact the ECN field is in the *lower* bits of the first 16-bit word of the
IP header when calculating in network byte order. This means that the
addition performed to update the checksum field was wrong; let's fix that.

Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
Reported-by: Jonathan Morton <chromatix99@gmail.com>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke HÃ¸iland-JÃ¸rgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20201130183705.17540-1-toke@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_ecn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -107,7 +107,7 @@ static inline int IP_ECN_set_ect1(struct
 	if ((iph->tos & INET_ECN_MASK) != INET_ECN_ECT_0)
 		return 0;
 
-	check += (__force u16)htons(0x100);
+	check += (__force u16)htons(0x1);
 
 	iph->check = (__force __sum16)(check + (check>=0xFFFF));
 	iph->tos ^= INET_ECN_MASK;


