Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFB37CD8C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhELQ4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243977AbhELQmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3825E61C6B;
        Wed, 12 May 2021 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835743;
        bh=7Jj4p4Ew1/jP+/8WWVsIZO8VRXusW8G6NW/eWRSipEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+1CHt7/ZJwW1VyhGvl4YoljT0s9P2qj1OYcVlYP4PSXvhNIqYkP247ZdJvkBfpzo
         Lx9Xw812KFY2hx5obgf4vMrUhJdOS7+jHPGavxd7ROY/Rs5eyFoAU/yxK+uTh/f7Dr
         jPKGaP906F76z4+HFpde2XrTptI/RnPYEcfj/EUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 450/677] libbpf: Add explicit padding to bpf_xdp_set_link_opts
Date:   Wed, 12 May 2021 16:48:16 +0200
Message-Id: <20210512144852.312870540@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit dde7b3f5f2f458297aeccfd4783e53ab8ca046db ]

Adding such anonymous padding fixes the issue with uninitialized portions of
bpf_xdp_set_link_opts when using LIBBPF_DECLARE_OPTS macro with inline field
initialization:

DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd = -1);

When such code is compiled in debug mode, compiler is generating code that
leaves padding bytes uninitialized, which triggers error inside libbpf APIs
that do strict zero initialization checks for OPTS structs.

Adding anonymous padding field fixes the issue.

Fixes: bd5ca3ef93cd ("libbpf: Add function to set link XDP fd while specifying old program")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210313210920.1959628-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3c35eb401931..3d690d4e785c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -507,6 +507,7 @@ struct xdp_link_info {
 struct bpf_xdp_set_link_opts {
 	size_t sz;
 	int old_fd;
+	size_t :0;
 };
 #define bpf_xdp_set_link_opts__last_field old_fd
 
-- 
2.30.2



