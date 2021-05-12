Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23F237C562
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhELPjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhELPeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:34:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6832E61988;
        Wed, 12 May 2021 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832641;
        bh=UoBPs+ib/MLJd/Zb/Kg7QX2w2kOvX+whXCVSfpeLZQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GB1PzowyR9Ls2s5ZVsV5lloc47pAXzeb4XhmqqKU90BgY4QydyAxulf+sUq9noXx
         qVJlm2NUue2zpj1m/i8KI6buvjQ+w4vpz1YOTnOnImErSlWp/vjhsJmtVEyVGLMWqD
         RUHGJB2dS1Eznz8dnEX5JvXOH3rPfr0RI594c5I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/530] libbpf: Add explicit padding to btf_dump_emit_type_decl_opts
Date:   Wed, 12 May 2021 16:47:52 +0200
Message-Id: <20210512144831.679489000@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 57247240a20a..9cabc8b620e3 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -164,6 +164,7 @@ struct btf_dump_emit_type_decl_opts {
 	int indent_level;
 	/* strip all the const/volatile/restrict mods */
 	bool strip_mods;
+	size_t :0;
 };
 #define btf_dump_emit_type_decl_opts__last_field strip_mods
 
-- 
2.30.2



