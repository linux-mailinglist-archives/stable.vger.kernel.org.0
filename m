Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA27B342C3F
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCTLeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhCTLdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:33:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C54B619BD;
        Sat, 20 Mar 2021 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616234045;
        bh=NmuoOvPQe76I3/1SY835ofZpqX5THiX50Kr1/o+QD7A=;
        h=From:To:Cc:Subject:Date:From;
        b=wDQEf9RkYUqb5JGHj5ivhmCDHN0ui9zzrVDSeJD+lkGJG4pS0uidjnVz9RSFNeVrJ
         tQTfWeqeqjP2imuli3oVAVBlZrMSRtA9SBDgMedJENg9mOFr/1EeG9F8Umvs1AB2Tv
         5FrlHLSaHPD+dEGDQjheocKsggbl243LjkhYtKbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.107
Date:   Sat, 20 Mar 2021 10:53:59 +0100
Message-Id: <16162340401564@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.107 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm64/include/asm/kvm_hyp.h                        |    3 
 arch/arm64/kvm/hyp/debug-sr.c                           |   24 +
 arch/arm64/kvm/hyp/switch.c                             |   13 
 arch/x86/crypto/aesni-intel_asm.S                       |  137 ++++++----
 arch/x86/crypto/aesni-intel_avx-x86_64.S                |   20 -
 arch/x86/crypto/aesni-intel_glue.c                      |   54 +---
 arch/x86/crypto/camellia_aesni_avx2_glue.c              |   74 ++---
 arch/x86/crypto/camellia_aesni_avx_glue.c               |   72 ++---
 arch/x86/crypto/camellia_glue.c                         |   45 +--
 arch/x86/crypto/cast6_avx_glue.c                        |   68 ++---
 arch/x86/crypto/glue_helper.c                           |   23 +
 arch/x86/crypto/serpent_avx2_glue.c                     |   65 ++--
 arch/x86/crypto/serpent_avx_glue.c                      |   63 ++--
 arch/x86/crypto/serpent_sse2_glue.c                     |   30 +-
 arch/x86/crypto/twofish_avx_glue.c                      |   75 ++---
 arch/x86/crypto/twofish_glue_3way.c                     |   37 +-
 arch/x86/include/asm/crypto/camellia.h                  |   63 ++--
 arch/x86/include/asm/crypto/glue_helper.h               |   18 -
 arch/x86/include/asm/crypto/serpent-avx.h               |   20 -
 arch/x86/include/asm/crypto/serpent-sse2.h              |   28 --
 arch/x86/include/asm/crypto/twofish.h                   |   19 -
 crypto/cast6_generic.c                                  |   18 -
 crypto/serpent_generic.c                                |    6 
 drivers/gpu/drm/i915/gvt/display.c                      |  212 ++++++++++++++++
 drivers/gpu/drm/i915/gvt/handlers.c                     |   40 ++-
 drivers/gpu/drm/i915/gvt/mmio.c                         |    5 
 drivers/gpu/drm/i915/gvt/vgpu.c                         |    5 
 drivers/net/dsa/b53/b53_common.c                        |   18 +
 drivers/net/dsa/b53/b53_regs.h                          |    1 
 drivers/net/dsa/bcm_sf2.c                               |    5 
 fs/btrfs/block-group.c                                  |   48 ++-
 fs/btrfs/block-group.h                                  |    3 
 fs/btrfs/relocation.c                                   |    2 
 fs/btrfs/scrub.c                                        |   21 +
 fs/fuse/fuse_i.h                                        |    1 
 include/crypto/cast6.h                                  |    4 
 include/crypto/serpent.h                                |    4 
 include/crypto/xts.h                                    |    2 
 kernel/bpf/verifier.c                                   |   33 +-
 net/dsa/tag_mtk.c                                       |   19 -
 tools/testing/selftests/bpf/verifier/bounds_deduction.c |   27 +-
 tools/testing/selftests/bpf/verifier/unpriv.c           |   15 +
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c  |   23 +
 44 files changed, 919 insertions(+), 546 deletions(-)

Amir Goldstein (1):
      fuse: fix live lock in fuse_iget()

Ard Biesheuvel (1):
      crypto: x86/aes-ni-xts - use direct calls to and 4-way stride

Colin Xu (5):
      drm/i915/gvt: Set SNOOP for PAT3 on BXT/APL to workaround GPU BB hang
      drm/i915/gvt: Fix mmio handler break on BXT/APL.
      drm/i915/gvt: Fix virtual display setup for BXT/APL
      drm/i915/gvt: Fix port number for BDW on EDID region setup
      drm/i915/gvt: Fix vfio_edid issue for BXT/APL

DENG Qingfang (1):
      net: dsa: tag_mtk: fix 802.1ad VLAN egress

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Greg Kroah-Hartman (1):
      Linux 5.4.107

Kees Cook (1):
      crypto: x86 - Regularize glue function prototypes

Piotr Krysiuk (5):
      bpf: Prohibit alu ops for pointer types not defining ptr_limit
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit
      bpf, selftests: Fix up some test_verifier cases for unprivileged

Qu Wenruo (1):
      btrfs: scrub: Don't check free space before marking a block group RO

Suzuki K Poulose (1):
      KVM: arm64: nvhe: Save the SPE context early

Uros Bizjak (1):
      crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg

