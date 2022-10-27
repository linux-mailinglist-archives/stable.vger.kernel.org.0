Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08960F6AD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbiJ0MCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbiJ0MCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:02:11 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F3B796A3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:02:09 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 10205C01C; Thu, 27 Oct 2022 14:02:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1666872130; bh=ynRHLt5yzfOlOzAy8yCedvQPXFbHdN9GJoW25QuTFuU=;
        h=From:To:Cc:Subject:Date:From;
        b=JizftHLxadjP68EUikrmT0rRt7BHUMEBjgN9Qm/beepw/Z28hGMV3e3Da4h/ItYBr
         KhL0m7DAKUr6FaTnGg/r2qkuL4k+m83aWTAXsv4sQD70HKxwTt97ezOq2lxDldyLhg
         RbmhbxKPgPaeq1EUp3ZHI6JR7HQyE3uUL1B5hIl/A2jwUe8hedHNdWTJsFCS0bvK7t
         do6hORfu1mvTghWFdpsR4wGNSqH5dYS1HDuSuZpuKiliF8pvS/mGycQVULia85RhE/
         VnA8SeAwOz9kdsGUHGv1XSrDKPx7aW04eYvkFRCuRJD2xeEHykAI2cEpHimrxorRCO
         c2bqYkAKxTRUg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 73A54C009;
        Thu, 27 Oct 2022 14:02:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1666872129; bh=ynRHLt5yzfOlOzAy8yCedvQPXFbHdN9GJoW25QuTFuU=;
        h=From:To:Cc:Subject:Date:From;
        b=1H3bIL67dFDt0tC/SPLOuGMxIs4cRfAF6+5KzEJmdr3vjITZGcI8sntKMV81syCig
         qzRp989gWWc7a5tKv7miROB6q252CGnWUko7DXOV/eDSUuk9m80nLkDQUX/95QR3FI
         2aAdI+EqHkhb/jUi/yMKO/w+lta0hNsUe6eJ3assfoIUhRmuKaDbk3zwHyKBoybelL
         2mIfS582VxOXDG4wSKN1eUdwKk2GYbNPU27ux8tcdzpq3RfYHUHekDyneVwEcupR4M
         vjRwBOFsqHH7FVhL3J0MdFIOJ0pdfrgVVaNk5BkEreOQ90Ac9ZkvRNgd6rTyTbQr+k
         HMhCmEWn3j74g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id bbdb16f6;
        Thu, 27 Oct 2022 12:02:01 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.10] kbuild: fix BTF build with pahole 1.24
Date:   Thu, 27 Oct 2022 21:01:58 +0900
Message-Id: <20221027120158.2791406-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pahole 1.24 broke builds on kernel <6.0 which do not have the
new BTF_KIND_ENUM64 BTF tag.
The 5.15 branch fixed this in commit b775fbf532dc01ae53a6fc56168fd30cb4b0c658
("kbuild: Add skip_encoding_btf_enum64 option to pahole"), which
we cannot use directly for 5.10 because 5.10 does not have the
pahole-flags.sh script, itself introduced in upstream commit
0baced0e0938f2895ceba54038eaf15ed91032e7 ("kbuild: Unify options
for BTF generation for vmlinux and modules")

that last commit is difficult to backport as 5.10 does not have BTF
for modules support: work around the problem by just copying the
pahole-flags.sh script and calling it directly in link-vmlinux.sh,
which is hopefully acceptable as the flags are not shared in this tree.

Note that compared to 5.15 the flags script does not have
--btf_gen_floats as linux 5.10 did not have that BTF tag yet;
but any new flag added to 5.15 will not be able to be added to 5.10 in
an identical way for any future breakage.

Cc: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
CC: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

This came up after updating nixpkgs to pahole 1.24.
https://github.com/NixOS/nixpkgs/pull/194551
Their 5.15's kernel built just fine as it already got some special
handling added, but since that handling was not added to other stable
kernels it started breaking builds after merging...

This shouldn't break anything, and should also as a byproduct fix some
builds with pahole 1.18 through 1.21 although I'm not sure if it never
has been backported to 5.10 because it's not a problem there or because
nobody cared (I probably only started caring after the 1.22 release)

Anyway, if more can be shared I think it'll make things simpler for
everyone going forward :)


 scripts/link-vmlinux.sh |  2 +-
 scripts/pahole-flags.sh | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100755 scripts/pahole-flags.sh

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d0b44bee9286..c24da7b68619 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -161,7 +161,7 @@ gen_btf()
 	vmlinux_link ${1}
 
 	info "BTF" ${2}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
+	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J $("${srctree}/scripts/pahole_flags.sh") ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
new file mode 100755
index 000000000000..8c82173e42e5
--- /dev/null
+++ b/scripts/pahole-flags.sh
@@ -0,0 +1,21 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+extra_paholeopt=
+
+if ! [ -x "$(command -v ${PAHOLE})" ]; then
+	exit 0
+fi
+
+pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+
+if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+fi
+
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
+echo ${extra_paholeopt}
-- 
2.37.3

