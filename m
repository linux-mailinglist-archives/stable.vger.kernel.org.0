Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45BD200FD2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393000AbgFSPWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392996AbgFSPWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3078321582;
        Fri, 19 Jun 2020 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580143;
        bh=0iFoIg7nV2CD2R+djatO1hodQJVSkJJ3Jzd7XRmEByk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSmDTa27ZHoPecETeKpLKoAOd0BUxxNW4LYnmpWdTJcCiNomjEYHaVqTVoM155g2d
         0nrirxo2uQLP1WQGki9CRNzvgAQp1VS2uzdEouxwGJJz/nDBg6OP4ipEm8ozo8u2dm
         P2XZa7j9nFAkI6hdrOor5BduvYmHIUwm1hR1rfKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        James Morse <james.morse@arm.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 138/376] arm64: kexec_file: print appropriate variable
Date:   Fri, 19 Jun 2020 16:30:56 +0200
Message-Id: <20200619141716.866608111@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 51075e0cb759a736e60ab4f3a5fed8670dba5852 ]

The value of kbuf->memsz may be different than kbuf->bufsz after calling
kexec_add_buffer(). Hence both values should be logged.

Fixes: 52b2a8af74360 ("arm64: kexec_file: load initrd and device-tree")
Fixes: 3751e728cef29 ("arm64: kexec_file: add crash dump support")
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: James Morse <james.morse@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Link: https://lore.kernel.org/r/20200430163142.27282-2-l.stelmach@samsung.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index b40c3b0def92..5ebb21b859b4 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -284,7 +284,7 @@ int load_other_segments(struct kimage *image,
 		image->arch.elf_headers_sz = headers_sz;
 
 		pr_debug("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			 image->arch.elf_headers_mem, headers_sz, headers_sz);
+			 image->arch.elf_headers_mem, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load initrd */
@@ -305,7 +305,7 @@ int load_other_segments(struct kimage *image,
 		initrd_load_addr = kbuf.mem;
 
 		pr_debug("Loaded initrd at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-				initrd_load_addr, initrd_len, initrd_len);
+				initrd_load_addr, kbuf.bufsz, kbuf.memsz);
 	}
 
 	/* load dtb */
@@ -332,7 +332,7 @@ int load_other_segments(struct kimage *image,
 	image->arch.dtb_mem = kbuf.mem;
 
 	pr_debug("Loaded dtb at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-			kbuf.mem, dtb_len, dtb_len);
+			kbuf.mem, kbuf.bufsz, kbuf.memsz);
 
 	return 0;
 
-- 
2.25.1



