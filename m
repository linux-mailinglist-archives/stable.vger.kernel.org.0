Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434424BAB8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgHTJ5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbgHTJ45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956AE207FB;
        Thu, 20 Aug 2020 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917417;
        bh=i962G2inrCZhyVPx+YuQR7dGciiioWMfgKAG1YVLAPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJAcXyPYXljAHHgINpBGjjNhjh35I2MsxGy/Z36sRU9+E3IW3Ztrv5oObiW5U2PpU
         BKUTF2kh+fCuIN0VkP3oqz2gi+rDNtJgLUM/H4RDIj/fNTrpFVKMiNcpCN5fsRL2VV
         zn+M91/D5FrP56WD7T/mdfb+jqbe+fj7VQ9ud8fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Rolf Eike Beer <eb@emlix.com>
Subject: [PATCH 4.9 023/212] install several missing uapi headers
Date:   Thu, 20 Aug 2020 11:19:56 +0200
Message-Id: <20200820091603.509780520@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

Commit fcc8487d477a3452a1d0ccbdd4c5e0e1e3cb8bed ("uapi: export all headers
under uapi directories") changed the default to install all headers not marked
to be conditional. This takes the list of headers listed in the commit message
and manually adds an export for those that are already present in this kernel
version.

Found during an attempt to build mtd-utils 2.1.2 as it wants hash_info.h, which
exists since 3.13 but has not been installed until the above mentioned commit,
which ended up in 4.12.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/uapi/asm/Kbuild    |    3 +++
 arch/powerpc/include/uapi/asm/Kbuild |    1 +
 include/uapi/drm/Kbuild              |    3 +++
 include/uapi/linux/Kbuild            |   20 ++++++++++++++++++++
 include/uapi/linux/cifs/Kbuild       |    1 +
 include/uapi/linux/genwqe/Kbuild     |    1 +
 6 files changed, 29 insertions(+)
 create mode 100644 include/uapi/linux/cifs/Kbuild
 create mode 100644 include/uapi/linux/genwqe/Kbuild

--- a/arch/mips/include/uapi/asm/Kbuild
+++ b/arch/mips/include/uapi/asm/Kbuild
@@ -39,3 +39,6 @@ header-y += termbits.h
 header-y += termios.h
 header-y += types.h
 header-y += unistd.h
+header-y += hwcap.h
+header-y += reg.h
+header-y += ucontext.h
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -45,3 +45,4 @@ header-y += tm.h
 header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h
+header-y += perf_regs.h
--- a/include/uapi/drm/Kbuild
+++ b/include/uapi/drm/Kbuild
@@ -20,3 +20,6 @@ header-y += vmwgfx_drm.h
 header-y += msm_drm.h
 header-y += vc4_drm.h
 header-y += virtgpu_drm.h
+header-y += armada_drm.h
+header-y += etnaviv_drm.h
+header-y += vgem_drm.h
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
--- /dev/null
+++ b/include/uapi/linux/cifs/Kbuild
@@ -0,0 +1 @@
+header-y += cifs_mount.h
--- /dev/null
+++ b/include/uapi/linux/genwqe/Kbuild
@@ -0,0 +1 @@
+header-y += genwqe_card.h


