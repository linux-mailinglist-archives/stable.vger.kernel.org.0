Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98D9739E5
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbfGXToo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390216AbfGXTon (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:44:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C0B22ADF;
        Wed, 24 Jul 2019 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997482;
        bh=VOnb5kOiGMZ0cNY597QFg4fANDtnMsXQpvosfI4lL1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VN+matR+FAhqhSTeOAtSyviz31bxOaNFTJxiJfv+5bj4l5Q105TTEAYaBXjgUBv75
         MHDM1wuzEX6zAUP7NziUA8GlGQJ4M3QNCBegE69BVtoBGZnIAd1xkoxB07e1VRa3x2
         svz4nmcbiKk+pKpoCgbVoX5AyCm6uX+He+GHjCp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Gupta <anirudh.gupta@sophos.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 040/371] xfrm: Fix xfrm sel prefix length validation
Date:   Wed, 24 Jul 2019 21:16:32 +0200
Message-Id: <20190724191727.560106578@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b38ff4075a80b4da5cb2202d7965332ca0efb213 ]

Family of src/dst can be different from family of selector src/dst.
Use xfrm selector family to validate address prefix length,
while verifying new sa from userspace.

Validated patch with this command:
ip xfrm state add src 1.1.6.1 dst 1.1.6.2 proto esp spi 4260196 \
reqid 20004 mode tunnel aead "rfc4106(gcm(aes))" \
0x1111016400000000000000000000000044440001 128 \
sel src 1011:1:4::2/128 sel dst 1021:1:4::2/128 dev Port5

Fixes: 07bf7908950a ("xfrm: Validate address prefix lengths in the xfrm selector.")
Signed-off-by: Anirudh Gupta <anirudh.gupta@sophos.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6916931b1de1..ee91f939903e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -150,6 +150,22 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 	err = -EINVAL;
 	switch (p->family) {
+	case AF_INET:
+		break;
+
+	case AF_INET6:
+#if IS_ENABLED(CONFIG_IPV6)
+		break;
+#else
+		err = -EAFNOSUPPORT;
+		goto out;
+#endif
+
+	default:
+		goto out;
+	}
+
+	switch (p->sel.family) {
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.20.1



