Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776703B538A
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhF0Nxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 09:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhF0Nxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 09:53:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8EEC061574;
        Sun, 27 Jun 2021 06:51:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kt19so423642pjb.2;
        Sun, 27 Jun 2021 06:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bTjmvU8yn2/k0kOaZkGNIygSTdPKkN7MOcxmayDA4lI=;
        b=OdGpBXHtWVue7u4/yCfRuucDLA2lcAkTkuHNxW38YjfxpCkbjgrsqMQvzAVvwzpbje
         NUAq5k3FZpGXY8LygkpAhG32cyPFaxj2z6HNiEjy8p1BNCvZhjSebCmuvnOvQwlGSxQu
         9Ub9gbmhiEFgsUYrNYChAT56HHUNvoeRw0kQJbLgE8wJKawlVYuY5U1p+dRNyYpIhJ9O
         FhDSmb9rQzHFG0svVN09s6BtJvfhn2MBda8/DIPGiy0pVsuvrWsu2AmFBHBvg1bjwgWo
         QIsi/O9P+d5PAkU/paZmZiuSXHhJk9qyKqNdJV2lt04OndwQpmNTgUkJmYvzH/JDvLrM
         CR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bTjmvU8yn2/k0kOaZkGNIygSTdPKkN7MOcxmayDA4lI=;
        b=exZLffKMhzFMNVP0gFOTvdd+C/qc2Q72tutgiOTQv0d8MI717i4Yu5IVG74Nq7+yLd
         pNq6WdoOkpU7utHOv/aK/JMaX3bY0zkzoXBdwdsrvdp7ut2/oKYYA8teSnHnrJD8wI+x
         riurOKNvdwD3I2dtO9d6ChROOfH0RRWU+cyxQC8H1h5Rn2GppkdCqSCHrP1r1knXZiR/
         IcPi1pjfFE0fNEcf1p0BNS4F4TAy1qu1cOgAeTdDx9bp5GP83x654OY4AP+b+xBnO1XL
         uIOnsuWJwtdjhY8UUrYlqODgH8/6OCzr4r2iwQpz0dvHWgBmt6fyLgAOgPMBvgGNJNy3
         oHHA==
X-Gm-Message-State: AOAM532F+Y/AajCVFgXuYm/PRRv51ez2H3tyen4YG+ZgmiDCJl8Z3TqR
        2LE3HgBU98eZzP+oyBRzf4I=
X-Google-Smtp-Source: ABdhPJzjT7YC09scR8s5v2+ndh3rZPHMTmEYf67yRO7QQ/E4qz+CXAbP8Mm+trT56tLJrtzz3o+voA==
X-Received: by 2002:a17:90a:b390:: with SMTP id e16mr22444595pjr.197.1624801887319;
        Sun, 27 Jun 2021 06:51:27 -0700 (PDT)
Received: from i9-aorus-gtx1080.localdomain (144.168.56.201.16clouds.com. [144.168.56.201])
        by smtp.gmail.com with ESMTPSA id c5sm10870034pfv.47.2021.06.27.06.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 06:51:26 -0700 (PDT)
From:   Bin Meng <bmeng.cn@gmail.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc:     stable@vger.kernel.org, Bin Meng <bmeng.cn@gmail.com>
Subject: [PATCH] riscv: Fix 32-bit RISC-V boot failure
Date:   Sun, 27 Jun 2021 21:51:17 +0800
Message-Id: <20210627135117.28641-1-bmeng.cn@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit dd2d082b5760 ("riscv: Cleanup setup_bootmem()") adjusted
the calling sequence in setup_bootmem(), which invalidates the fix
commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
did for 32-bit RISC-V unfortunately.

So now 32-bit RISC-V does not boot again when testing booting kernel
on QEMU 'virt' with '-m 2G', which was exactly what the original
commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
tried to fix.

Fixes: dd2d082b5760 ("riscv: Cleanup setup_bootmem()")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Bin Meng <bmeng.cn@gmail.com>
---

 arch/riscv/mm/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 4c4c92ce0bb8..9b23b95c50cf 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -123,7 +123,7 @@ void __init setup_bootmem(void)
 {
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
-	phys_addr_t dram_end = memblock_end_of_DRAM();
+	phys_addr_t dram_end;
 	phys_addr_t max_mapped_addr = __pa(~(ulong)0);
 
 #ifdef CONFIG_XIP_KERNEL
@@ -146,6 +146,8 @@ void __init setup_bootmem(void)
 #endif
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
+	dram_end = memblock_end_of_DRAM();
+
 	/*
 	 * memblock allocator is not aware of the fact that last 4K bytes of
 	 * the addressable memory can not be mapped because of IS_ERR_VALUE
-- 
2.25.1

