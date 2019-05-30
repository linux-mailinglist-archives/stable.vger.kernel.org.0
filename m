Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0B2F037
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbfE3DSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731410AbfE3DSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663FF24755;
        Thu, 30 May 2019 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186284;
        bh=giia1H8fV3MI0n0b6NEl9yVmTOqXajqyIE74fhzbvmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNwm1GheKEJrzYLCy24aqfsU4m5YFQjXmIBuwDqxd2bAJEHSz5OOLpOE4CND13mF0
         j+Uj3bi8zeuENH+5nu07IQ7FtL9+/5YDelDV3s7xjyIj7xSPrfgLK/PSfMmAvqlekL
         K2DsxKRlD7I5I7W/U7MJvzW2inK63d8NZwV9Jaw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 238/276] selinux: avoid uninitialized variable warning
Date:   Wed, 29 May 2019 20:06:36 -0700
Message-Id: <20190530030540.009046196@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 98bbbb76f2edcfb8fb2b8f4b3ccc7b6e99d64bd8 ]

clang correctly points out a code path that would lead
to an uninitialized variable use:

security/selinux/netlabel.c:310:6: error: variable 'addr' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
        if (ip_hdr(skb)->version == 4) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~
security/selinux/netlabel.c:322:40: note: uninitialized use occurs here
        rc = netlbl_conn_setattr(ep->base.sk, addr, &secattr);
                                              ^~~~
security/selinux/netlabel.c:310:2: note: remove the 'if' if its condition is always true
        if (ip_hdr(skb)->version == 4) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
security/selinux/netlabel.c:291:23: note: initialize the variable 'addr' to silence this warning
        struct sockaddr *addr;
                             ^
                              = NULL

This is probably harmless since we should not see ipv6 packets
of CONFIG_IPV6 is disabled, but it's better to rearrange the code
so this cannot happen.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[PM: removed old patchwork link, fixed checkpatch.pl style errors]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/netlabel.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 186e727b737b9..6fd9954e1c085 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -288,11 +288,8 @@ int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
 	int rc;
 	struct netlbl_lsm_secattr secattr;
 	struct sk_security_struct *sksec = ep->base.sk->sk_security;
-	struct sockaddr *addr;
 	struct sockaddr_in addr4;
-#if IS_ENABLED(CONFIG_IPV6)
 	struct sockaddr_in6 addr6;
-#endif
 
 	if (ep->base.sk->sk_family != PF_INET &&
 				ep->base.sk->sk_family != PF_INET6)
@@ -310,16 +307,15 @@ int selinux_netlbl_sctp_assoc_request(struct sctp_endpoint *ep,
 	if (ip_hdr(skb)->version == 4) {
 		addr4.sin_family = AF_INET;
 		addr4.sin_addr.s_addr = ip_hdr(skb)->saddr;
-		addr = (struct sockaddr *)&addr4;
-#if IS_ENABLED(CONFIG_IPV6)
-	} else {
+		rc = netlbl_conn_setattr(ep->base.sk, (void *)&addr4, &secattr);
+	} else if (IS_ENABLED(CONFIG_IPV6) && ip_hdr(skb)->version == 6) {
 		addr6.sin6_family = AF_INET6;
 		addr6.sin6_addr = ipv6_hdr(skb)->saddr;
-		addr = (struct sockaddr *)&addr6;
-#endif
+		rc = netlbl_conn_setattr(ep->base.sk, (void *)&addr6, &secattr);
+	} else {
+		rc = -EAFNOSUPPORT;
 	}
 
-	rc = netlbl_conn_setattr(ep->base.sk, addr, &secattr);
 	if (rc == 0)
 		sksec->nlbl_state = NLBL_LABELED;
 
-- 
2.20.1



