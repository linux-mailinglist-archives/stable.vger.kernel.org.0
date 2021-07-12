Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093B93C4E29
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbhGLHRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242887AbhGLHQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1967E6142B;
        Mon, 12 Jul 2021 07:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073992;
        bh=cSu2LUiyAHdYlTxcZhO6RT6ysIK7Ga2Eoxbch6DRBbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONsBOtyTQ/HR+xM7RgluY5tjxMhwaWINH/GOGDlr4hzhCdGTLx0btxAupah+mF+FX
         jVzhCwWQrj3Z0pR9Z2P9D8aibA1n+nJMqMWA58gMyBYoBR7JoCWCYqv1cOxXVr6nfN
         8wazJlzUtw5g3ICeYBcpR/pfh23H/q/1zwVweigY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, Frank Eigler <fche@redhat.com>,
        Mark Wielaard <mark@klomp.org>, Jiri Olsa <jolsa@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 427/700] bpf: Fix libelf endian handling in resolv_btfids
Date:   Mon, 12 Jul 2021 08:08:30 +0200
Message-Id: <20210712061021.837546242@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 61e8aeda9398925f8c6fc290585bdd9727d154c4 ]

The vmlinux ".BTF_ids" ELF section is declared in btf_ids.h to hold a list
of zero-filled BTF IDs, which is then patched at link-time with correct
values by resolv_btfids. The section is flagged as "allocable" to preclude
compression, but notably the section contents (BTF IDs) are untyped.

When patching the BTF IDs, resolve_btfids writes in host-native endianness
and relies on libelf for any required translation on reading and updating
vmlinux. However, since the type of the .BTF_ids section content defaults
to ELF_T_BYTE (i.e. unsigned char), no translation occurs. This results in
incorrect patched values when cross-compiling to non-native endianness,
and can manifest as kernel Oops and test failures which are difficult to
troubleshoot [1].

Explicitly set the type of patched data to ELF_T_WORD, the architecture-
neutral ELF type corresponding to the u32 BTF IDs. This enables libelf to
transparently perform any needed endian conversions.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frank Eigler <fche@redhat.com>
Cc: Mark Wielaard <mark@klomp.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com [1]
Link: https://lore.kernel.org/bpf/20210618061404.818569-1-Tony.Ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 80d966cfcaa1..7ce4558a932f 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -656,6 +656,9 @@ static int symbols_patch(struct object *obj)
 	if (sets_patch(obj))
 		return -1;
 
+	/* Set type to ensure endian translation occurs. */
+	obj->efile.idlist->d_type = ELF_T_WORD;
+
 	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
 
 	err = elf_update(obj->efile.elf, ELF_C_WRITE);
-- 
2.30.2



