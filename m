Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A90B147A77
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgAXJdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbgAXJdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:50 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D35392070A;
        Fri, 24 Jan 2020 09:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858429;
        bh=6ATBr/q3K+e1dGwhVS4xetbiAS+uK2bdQteEk00gXNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYEc1KVxwRmfI17DKT/8y/vMm/9+0VYwtRT3p9OitOUmHBa/aqRrmcsjT7er5P97y
         DGugurkCZGwD3fI4H2JdU5YxJq26rM3p1gqxByM8/+cgY9i3aouWY6Da3Ft+q8FuXD
         l82/yPbPSnqUz+eS0socEiWXp4cd5pNSX+uvT7Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.4 008/102] bpf: Force .BTF section start to zero when dumping from vmlinux
Date:   Fri, 24 Jan 2020 10:30:09 +0100
Message-Id: <20200124092807.300536423@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

commit df786c9b947639aedbc7bb44b5dae2a7824af360 upstream.

While trying to figure out why fentry_fexit selftest doesn't pass for me
(old pahole, broken BTF), I found out that my latest patch can break vmlinux
.BTF generation. objcopy preserves section start when doing --only-section,
so there is a chance (depending on where pahole inserts .BTF section) to
have leading empty zeroes. Let's explicitly force section offset to zero.

Before:

$ objcopy --set-section-flags .BTF=alloc -O binary \
	--only-section=.BTF vmlinux .btf.vmlinux.bin
$ xxd .btf.vmlinux.bin | head -n1
00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................

After:

$ objcopy --change-section-address .BTF=0 \
	--set-section-flags .BTF=alloc -O binary \
	--only-section=.BTF vmlinux .btf.vmlinux.bin
$ xxd .btf.vmlinux.bin | head -n1
00000000: 9feb 0100 1800 0000 0000 0000 80e1 1c00  ................
          ^BTF magic

As part of this change, I'm also dropping '2>/dev/null' from objcopy
invocation to be able to catch possible other issues (objcopy doesn't
produce any warnings for me anymore, it did before with --dump-section).

Fixes: da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191127225759.39923-1-sdf@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/link-vmlinux.sh |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -127,8 +127,9 @@ gen_btf()
 		cut -d, -f1 | cut -d' ' -f2)
 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
 		awk '{print $4}')
-	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
+	${OBJCOPY} --change-section-address .BTF=0 \
+		--set-section-flags .BTF=alloc -O binary \
+		--only-section=.BTF ${1} .btf.vmlinux.bin
 	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
 		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
 }


