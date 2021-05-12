Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BFF37C9B6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbhELQUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239753AbhELQPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FE261D5F;
        Wed, 12 May 2021 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834163;
        bh=VB28mPWdH4KirLLdSUaNiRYYApU6S+b4HnMC6npyQmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVR7D8TdFefXweUHYxc/VGcDYwANpIrGIvCQ5gMHNLPaj6vwqTMuzPn+pIhWj5Wg+
         5Az2YlgtrOvkf5DzcPST3YsAJzLxGjZ5KpfIIC+D29Ahby+2Ul1JFxqQc5pRzKFFp0
         FUItR5f3EbsTVjWyS5jsYoTq3jPAizWq3g8B4u0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 406/601] libbpf: Add explicit padding to btf_dump_emit_type_decl_opts
Date:   Wed, 12 May 2021 16:48:03 +0200
Message-Id: <20210512144841.195369319@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit ea24b19562fe5f72c78319dbb347b701818956d9 ]

Similar to
https://lore.kernel.org/bpf/20210313210920.1959628-2-andrii@kernel.org/

When DECLARE_LIBBPF_OPTS is used with inline field initialization, e.g:

  DECLARE_LIBBPF_OPTS(btf_dump_emit_type_decl_opts, opts,
    .field_name = var_ident,
    .indent_level = 2,
    .strip_mods = strip_mods,
  );

and compiled in debug mode, the compiler generates code which
leaves the padding uninitialized and triggers errors within libbpf APIs
which require strict zero initialization of OPTS structs.

Adding anonymous padding field fixes the issue.

Fixes: 9f81654eebe8 ("libbpf: Expose BTF-to-C type declaration emitting API")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210319192117.2310658-1-kpsingh@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1237bcd1dd17..5b8a6ea44b38 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -173,6 +173,7 @@ struct btf_dump_emit_type_decl_opts {
 	int indent_level;
 	/* strip all the const/volatile/restrict mods */
 	bool strip_mods;
+	size_t :0;
 };
 #define btf_dump_emit_type_decl_opts__last_field strip_mods
 
-- 
2.30.2



