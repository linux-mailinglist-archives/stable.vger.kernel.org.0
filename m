Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF847ADD1
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhLTOzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60820 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbhLTOyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:54:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEE2DB80EE2;
        Mon, 20 Dec 2021 14:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876FC36AE7;
        Mon, 20 Dec 2021 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012047;
        bh=GYR1Wgh0HO4YY+mBpA57RoUFz6fyYrJxzqkN0yCQXbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xtpquh4MlRrGJs0PRli+nN18Ymjt/RWiGdfAoyb5Bk/xUv4iOxeulqIjp/7Jx2q2k
         RHjCorCu3eSsTBXw35wqKtwJlxp9TrK5a62533CGoVQLcykrG6jJlv2qS7xeWR43ns
         FOlxFfj8TIEyS+zMBd7fgSsZJzSxnOhroc7kEc0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <ltao@redhat.com>,
        Philipp Rudo <prudo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/177] s390/kexec_file: fix error handling when applying relocations
Date:   Mon, 20 Dec 2021 15:33:30 +0100
Message-Id: <20211220143042.127672005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@redhat.com>

[ Upstream commit 41967a37b8eedfee15b81406a9f3015be90d3980 ]

arch_kexec_apply_relocations_add currently ignores all errors returned
by arch_kexec_do_relocs. This means that every unknown relocation is
silently skipped causing unpredictable behavior while the relocated code
runs. Fix this by checking for errors and fail kexec_file_load if an
unknown relocation type is encountered.

The problem was found after gcc changed its behavior and used
R_390_PLT32DBL relocations for brasl instruction and relied on ld to
resolve the relocations in the final link in case direct calls are
possible. As the purgatory code is only linked partially (option -r)
ld didn't resolve the relocations leaving them for arch_kexec_do_relocs.
But arch_kexec_do_relocs doesn't know how to handle R_390_PLT32DBL
relocations so they were silently skipped. This ultimately caused an
endless loop in the purgatory as the brasl instructions kept branching
to itself.

Fixes: 71406883fd35 ("s390/kexec_file: Add kexec_file_load system call")
Reported-by: Tao Liu <ltao@redhat.com>
Signed-off-by: Philipp Rudo <prudo@redhat.com>
Link: https://lore.kernel.org/r/20211208130741.5821-3-prudo@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/machine_kexec_file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index e7435f3a3d2d2..76cd09879eaf4 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -277,6 +277,7 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 {
 	Elf_Rela *relas;
 	int i, r_type;
+	int ret;
 
 	relas = (void *)pi->ehdr + relsec->sh_offset;
 
@@ -311,7 +312,11 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 		addr = section->sh_addr + relas[i].r_offset;
 
 		r_type = ELF64_R_TYPE(relas[i].r_info);
-		arch_kexec_do_relocs(r_type, loc, val, addr);
+		ret = arch_kexec_do_relocs(r_type, loc, val, addr);
+		if (ret) {
+			pr_err("Unknown rela relocation: %d\n", r_type);
+			return -ENOEXEC;
+		}
 	}
 	return 0;
 }
-- 
2.33.0



