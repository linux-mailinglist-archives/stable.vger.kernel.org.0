Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC671478C72
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhLQNi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLQNi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:38:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F9CC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC7B2621E8
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 13:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89660C36AE8;
        Fri, 17 Dec 2021 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639748308;
        bh=Ce/wTmQvQlgitw8iArshDwBKzHI4KB+PY+Zt6ASgGjw=;
        h=Subject:To:Cc:From:Date:From;
        b=GNNB7UFWYeBdKdQ128E5CmS7magb8eMsjd73XwzKIkXcQ3qN8Uuds9ZQ2w5I5wfhM
         49F1+CnC54mWazZ3svqK8fc/AwtIWDO6Ot1EUu8Dc6yEz3F6j7loC+sh6SDiQt085m
         Cjx4SPBog79CYCbwcdXOe+QgbZq4s2qH3AFid6/U=
Subject: FAILED: patch "[PATCH] s390/kexec: handle R_390_PLT32DBL rela in" failed to apply to 5.15-stable tree
To:     egorenar@linux.ibm.com, hca@linux.ibm.com, ltao@redhat.com,
        prudo@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Dec 2021 14:38:25 +0100
Message-ID: <1639748305210135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From abf0e8e4ef25478a4390115e6a953d589d1f9ffd Mon Sep 17 00:00:00 2001
From: Alexander Egorenkov <egorenar@linux.ibm.com>
Date: Thu, 9 Dec 2021 08:38:17 +0100
Subject: [PATCH] s390/kexec: handle R_390_PLT32DBL rela in
 arch_kexec_apply_relocations_add()

Starting with gcc 11.3, the C compiler will generate PLT-relative function
calls even if they are local and do not require it. Later on during linking,
the linker will replace all PLT-relative calls to local functions with
PC-relative ones. Unfortunately, the purgatory code of kexec/kdump is
not being linked as a regular executable or shared library would have been,
and therefore, all PLT-relative addresses remain in the generated purgatory
object code unresolved. This leads to the situation where the purgatory
code is being executed during kdump with all PLT-relative addresses
unresolved. And this results in endless loops within the purgatory code.

Furthermore, the clang C compiler has always behaved like described above
and this commit should fix kdump for kernels built with the latter.

Because the purgatory code is no regular executable or shared library,
contains only calls to local functions and has no PLT, all R_390_PLT32DBL
relocation entries can be resolved just like a R_390_PC32DBL one.

* https://refspecs.linuxfoundation.org/ELF/zSeries/lzsabi0_zSeries/x1633.html#AEN1699

Relocation entries of purgatory code generated with gcc 11.3
------------------------------------------------------------

$ readelf -r linux/arch/s390/purgatory/purgatory.o

Relocation section '.rela.text' at offset 0x370 contains 5 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
00000000005c  000c00000013 R_390_PC32DBL     0000000000000000 purgatory_sha_regions + 2
00000000007a  000d00000014 R_390_PLT32DBL    0000000000000000 sha256_update + 2
00000000008c  000e00000014 R_390_PLT32DBL    0000000000000000 sha256_final + 2
000000000092  000800000013 R_390_PC32DBL     0000000000000000 .LC0 + 2
0000000000a0  000f00000014 R_390_PLT32DBL    0000000000000000 memcmp + 2

Relocation entries of purgatory code generated with gcc 11.2
------------------------------------------------------------

$ readelf -r linux/arch/s390/purgatory/purgatory.o

Relocation section '.rela.text' at offset 0x368 contains 5 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
00000000005c  000c00000013 R_390_PC32DBL     0000000000000000 purgatory_sha_regions + 2
00000000007a  000d00000013 R_390_PC32DBL     0000000000000000 sha256_update + 2
00000000008c  000e00000013 R_390_PC32DBL     0000000000000000 sha256_final + 2
000000000092  000800000013 R_390_PC32DBL     0000000000000000 .LC0 + 2
0000000000a0  000f00000013 R_390_PC32DBL     0000000000000000 memcmp + 2

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reported-by: Tao Liu <ltao@redhat.com>
Suggested-by: Philipp Rudo <prudo@redhat.com>
Reviewed-by: Philipp Rudo <prudo@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211209073817.82196-1-egorenar@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index 876cdd3c994e..8f43575a4dd3 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -348,6 +348,10 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 		addr = section->sh_addr + relas[i].r_offset;
 
 		r_type = ELF64_R_TYPE(relas[i].r_info);
+
+		if (r_type == R_390_PLT32DBL)
+			r_type = R_390_PC32DBL;
+
 		ret = arch_kexec_do_relocs(r_type, loc, val, addr);
 		if (ret) {
 			pr_err("Unknown rela relocation: %d\n", r_type);

