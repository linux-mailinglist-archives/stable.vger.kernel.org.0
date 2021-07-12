Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D483C53D5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348839AbhGLH4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350724AbhGLHvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD5461432;
        Mon, 12 Jul 2021 07:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076060;
        bh=+aM4i4J7M0YxZ389qnDW7KEGrT3myv5TtXd0q2clvaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbPcw+y8bisP/fTi4uj/3QVylwIhIbSFBVobzfCsk1wSDaSLQGqgWEjzDKggM8NMI
         KsJq+whUTGYoSOsfb0MKN2xHtZzmoqel2QKmVCDocVSg2OzasgkDBZBnoVAK6r9hD/
         0010ZiOYb4iqjl36zb9+gsc/S374pretUHBDZq7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, Frank Eigler <fche@redhat.com>,
        Mark Wielaard <mark@klomp.org>, Jiri Olsa <jolsa@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 482/800] bpf: Fix libelf endian handling in resolv_btfids
Date:   Mon, 12 Jul 2021 08:08:25 +0200
Message-Id: <20210712061018.469169346@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 7550fd9c3188..3ad9301b0f00 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -655,6 +655,9 @@ static int symbols_patch(struct object *obj)
 	if (sets_patch(obj))
 		return -1;
 
+	/* Set type to ensure endian translation occurs. */
+	obj->efile.idlist->d_type = ELF_T_WORD;
+
 	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
 
 	err = elf_update(obj->efile.elf, ELF_C_WRITE);
-- 
2.30.2



