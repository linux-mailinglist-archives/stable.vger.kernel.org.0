Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5FB73ACB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404235AbfGXTxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404241AbfGXTxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A439922ADA;
        Wed, 24 Jul 2019 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998030;
        bh=XCRvcFMH9hXvqaVK+9zIaKSTL5zpL8XnoLWiAkMwm1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJc9qBMKh2sMKraSZhPWsBtdHAkxUzbkONVVqlj0KVUMTlqaXLwkqRRgIFtmwAKVb
         0TfxDhXJd6aswHszOFXkAHPTQXFPIIeejC22a/yd3L/BJjLmwjGl4T3FJf3sXFfOVB
         oSYusuUXwdnSM++zH//dLJzYA4ZX1I95fk25vBcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 223/371] libbpf: fix another GCC8 warning for strncpy
Date:   Wed, 24 Jul 2019 21:19:35 +0200
Message-Id: <20190724191741.313180904@linuxfoundation.org>
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

[ Upstream commit 763ff0e7d9c72e7094b31e7fb84a859be9325635 ]

Similar issue was fixed in cdfc7f888c2a ("libbpf: fix GCC8 warning for
strncpy") already. This one was missed. Fixing now.

Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 1fe0e1eec738..4ecd33ff46ec 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -560,7 +560,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		err = -errno;
 		goto out_socket;
 	}
-	strncpy(xsk->ifname, ifname, IFNAMSIZ);
+	strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
+	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
 	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
 	if (err)
-- 
2.20.1



