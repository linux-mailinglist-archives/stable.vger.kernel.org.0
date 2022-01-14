Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4848E5C0
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbiANIUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239703AbiANIT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA80C061753;
        Fri, 14 Jan 2022 00:19:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43582B82434;
        Fri, 14 Jan 2022 08:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B6C36AEA;
        Fri, 14 Jan 2022 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148366;
        bh=1flfSfRoaivljG0UplxuwrG6XKUGJPjjvXsbdRvGmAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/sIOMK23U+Kgsu5XDXqF/yoZMUeuLQ1wjs03kvcwQzoddaiZVKhI2ffI9i9OOnK2
         fhOcRAAdIIa3ek+h5Bof5+aPdUxIhdQsWiZ9x1/kAOLs4Zg/xdJQ9U4u4DsYzKyRX9
         Mpsmgyk7gSR35wbpy1+1ChBdNWcSmv3/jHOc828w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Tao Liu <ltao@redhat.com>, Philipp Rudo <prudo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 01/41] s390/kexec: handle R_390_PLT32DBL rela in arch_kexec_apply_relocations_add()
Date:   Fri, 14 Jan 2022 09:16:01 +0100
Message-Id: <20220114081545.207536135@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit abf0e8e4ef25478a4390115e6a953d589d1f9ffd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/machine_kexec_file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -312,6 +312,10 @@ int arch_kexec_apply_relocations_add(str
 		addr = section->sh_addr + relas[i].r_offset;
 
 		r_type = ELF64_R_TYPE(relas[i].r_info);
+
+		if (r_type == R_390_PLT32DBL)
+			r_type = R_390_PC32DBL;
+
 		ret = arch_kexec_do_relocs(r_type, loc, val, addr);
 		if (ret) {
 			pr_err("Unknown rela relocation: %d\n", r_type);


