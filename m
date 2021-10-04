Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2134042101F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbhJDNkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238601AbhJDNit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82EB61A0A;
        Mon,  4 Oct 2021 13:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353479;
        bh=uoMf1+hsN95PKka+eoDM0rxqI08IIvpmXf9abmwz9Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUajMBw9PQz9rMWx1e3IuU5ZnDqlsRqjPb8O6tf35ITAzh9F1EWvNfjL4uo1GZqrL
         va1Uy6LQnX/8Tb99oPa74TVCnq7kvEB35S4VR1DsfspqTpXv2NPsGhpxRuO52Qe3yL
         hPaFO+u44G1NIxsKGSauOLULbw1+YHPW1RYmaKyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 145/172] elf: dont use MAP_FIXED_NOREPLACE for elf interpreter mappings
Date:   Mon,  4 Oct 2021 14:53:15 +0200
Message-Id: <20211004125049.646298071@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jingwen <chenjingwen6@huawei.com>

commit 9b2f72cc0aa4bb444541bb87581c35b7508b37d3 upstream.

In commit b212921b13bd ("elf: don't use MAP_FIXED_NOREPLACE for elf
executable mappings") we still leave MAP_FIXED_NOREPLACE in place for
load_elf_interp.

Unfortunately, this will cause kernel to fail to start with:

    1 (init): Uhuuh, elf segment at 00003ffff7ffd000 requested but the memory is mapped already
    Failed to execute /init (error -17)

The reason is that the elf interpreter (ld.so) has overlapping segments.

  readelf -l ld-2.31.so
  Program Headers:
    Type           Offset             VirtAddr           PhysAddr
                   FileSiz            MemSiz              Flags  Align
    LOAD           0x0000000000000000 0x0000000000000000 0x0000000000000000
                   0x000000000002c94c 0x000000000002c94c  R E    0x10000
    LOAD           0x000000000002dae0 0x000000000003dae0 0x000000000003dae0
                   0x00000000000021e8 0x0000000000002320  RW     0x10000
    LOAD           0x000000000002fe00 0x000000000003fe00 0x000000000003fe00
                   0x00000000000011ac 0x0000000000001328  RW     0x10000

The reason for this problem is the same as described in commit
ad55eac74f20 ("elf: enforce MAP_FIXED on overlaying elf segments").

Not only executable binaries, elf interpreters (e.g. ld.so) can have
overlapping elf segments, so we better drop MAP_FIXED_NOREPLACE and go
back to MAP_FIXED in load_elf_interp.

Fixes: 4ed28639519c ("fs, elf: drop MAP_FIXED usage from elf_map")
Cc: <stable@vger.kernel.org> # v4.19
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Chen Jingwen <chenjingwen6@huawei.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -630,7 +630,7 @@ static unsigned long load_elf_interp(str
 
 			vaddr = eppnt->p_vaddr;
 			if (interp_elf_ex->e_type == ET_EXEC || load_addr_set)
-				elf_type |= MAP_FIXED_NOREPLACE;
+				elf_type |= MAP_FIXED;
 			else if (no_base && interp_elf_ex->e_type == ET_DYN)
 				load_addr = -vaddr;
 


