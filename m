Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48D32332BC
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgG3NLf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Jul 2020 09:11:35 -0400
Received: from mx1.emlix.com ([188.40.240.192]:55966 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgG3NLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:11:34 -0400
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id F08E15F77B;
        Thu, 30 Jul 2020 15:01:45 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH 4.9.y 2/2] install several missing uapi headers
Date:   Thu, 30 Jul 2020 15:01:45 +0200
Message-ID: <2892097.ECyh5nn9PN@devpool35>
Organization: emlix GmbH
In-Reply-To: <2225723.ZPmVZEtQ53@devpool35>
References: <2225723.ZPmVZEtQ53@devpool35>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit fcc8487d477a3452a1d0ccbdd4c5e0e1e3cb8bed ("uapi: export all headers
under uapi directories") changed the default to install all headers not marked
to be conditional. This takes the list of headers listed in the commit message
and manually adds an export for those that are already present in this kernel
version.

Found during an attempt to build mtd-utils 2.1.2 as it wants hash_info.h, which
exists since 3.13 but has not been installed until the above mentioned commit,
which ended up in 4.12.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
---
 arch/mips/include/uapi/asm/Kbuild    |  3 +++
 arch/powerpc/include/uapi/asm/Kbuild |  1 +
 include/uapi/drm/Kbuild              |  3 +++
 include/uapi/linux/Kbuild            | 20 ++++++++++++++++++++
 include/uapi/linux/cifs/Kbuild       |  2 ++
 include/uapi/linux/genwqe/Kbuild     |  2 ++
 6 files changed, 31 insertions(+)
 create mode 100644 include/uapi/linux/cifs/Kbuild
 create mode 100644 include/uapi/linux/genwqe/Kbuild

diff --git a/arch/mips/include/uapi/asm/Kbuild b/arch/mips/include/uapi/asm/Kbuild
index f2cf41461146..6298280cb2fe 100644
--- a/arch/mips/include/uapi/asm/Kbuild
+++ b/arch/mips/include/uapi/asm/Kbuild
@@ -39,3 +39,6 @@ header-y += termbits.h
 header-y += termios.h
 header-y += types.h
 header-y += unistd.h
+header-y += hwcap.h
+header-y += reg.h
+header-y += ucontext.h
diff --git a/arch/powerpc/include/uapi/asm/Kbuild b/arch/powerpc/include/uapi/asm/Kbuild
index dab3717e3ea0..95cff4782218 100644
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -45,3 +45,4 @@ header-y += tm.h
 header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h
+header-y += perf_regs.h
diff --git a/include/uapi/drm/Kbuild b/include/uapi/drm/Kbuild
index 9355dd8eff3b..489b093580dd 100644
--- a/include/uapi/drm/Kbuild
+++ b/include/uapi/drm/Kbuild
@@ -20,3 +20,6 @@ header-y += vmwgfx_drm.h
 header-y += msm_drm.h
 header-y += vc4_drm.h
 header-y += virtgpu_drm.h
+header-y += armada_drm.h
+header-y += etnaviv_drm.h
+header-y += vgem_drm.h
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index cd2be1c8e9fb..39bf68b36332 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -475,3 +475,23 @@ header-y += xilinx-v4l2-controls.h
 header-y += zorro.h
 header-y += zorro_ids.h
 header-y += userfaultfd.h
+header-y += auto_dev-ioctl.h
+header-y += bcache.h
+header-y += btrfs_tree.h
+header-y += coresight-stm.h
+header-y += cryptouser.h
+header-y += hash_info.h
+header-y += kcm.h
+header-y += kcov.h
+header-y += kfd_ioctl.h
+header-y += lightnvm.h
+header-y += module.h
+header-y += nilfs2_api.h
+header-y += nilfs2_ondisk.h
+header-y += nsfs.h
+header-y += pr.h
+header-y += qrtr.h
+header-y += stm.h
+header-y += wil6210_uapi.h
+header-y += cifs/
+header-y += genwqe/
diff --git a/include/uapi/linux/cifs/Kbuild b/include/uapi/linux/cifs/Kbuild
new file mode 100644
index 000000000000..6a4a65811cd5
--- /dev/null
+++ b/include/uapi/linux/cifs/Kbuild
@@ -0,0 +1,1 @@
+header-y += cifs_mount.h
diff --git a/include/uapi/linux/genwqe/Kbuild b/include/uapi/linux/genwqe/Kbuild
new file mode 100644
index 000000000000..b1e3eb6a4fe9
--- /dev/null
+++ b/include/uapi/linux/genwqe/Kbuild
@@ -0,0 +1,1 @@
+header-y += genwqe_card.h
-- 
2.27.0

-- 
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Heike Jordan, Dr. Uwe Kracke – Ust-IdNr.: DE 205 198 055

emlix - smart embedded open source



