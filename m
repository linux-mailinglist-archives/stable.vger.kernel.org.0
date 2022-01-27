Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF649EC00
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 21:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbiA0UDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 15:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343793AbiA0UDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 15:03:02 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F1C06173B
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 12:03:02 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e28so3799937pfj.5
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 12:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=subject:date:message-id:mime-version:content-transfer-encoding:cc
         :from:to;
        bh=pS6oAPlQasQLltOWbX6ybr6410G9JsawVRKiZZSuto0=;
        b=OkmBR46itpSo80eYP7SfR78XlDnMDrL9T8FDPQBDH5rBgiD3BZFfwLp2IIx2tdkHR+
         ttRdpr4UVF+iNyhTIs3m0ikyxmU9eeIljF9uOY9Wc2sJLPWeE3QoI2R21yFiy2C4hYY7
         qP+0Cueu8u3d84NnxZgzByglJXfgi37r0teIb2DzgVYRuND/lMRdW3Myoloks8Lc6IR2
         a4SRgnrJi5GxFgixdCQnkHAwOVTjduufc9hxgByV58qNLUFcYCziJdvmlF2DMzSzc5Ax
         mE1T78oc8dnShG9T0WwD8JfGPgAQnfc03kPCxAzDENXCdRj7VHYVAj942yBXtMeCxx1w
         7inQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=pS6oAPlQasQLltOWbX6ybr6410G9JsawVRKiZZSuto0=;
        b=FvuiC42PzF/iH+9B8ftszB9WyP7C6GXSWbBOwqlxYqEgvBqRctB2yfIzphzADxJi+w
         COlVtVaHSHZuhxOuwDmDIwPjRCtYc+pKc2VCgQ7eKddp8DDUnfdInJmMK2FZ97kWTyuv
         a+7XLK3dxy/cH4XH9HyHehPbu+XHXeik8+xTATU9wIrGwfQmO484f8Zb2Ge5vRu1C0OE
         zZvfa6+7L8ICoCf+4EU+44O6Efp+jrNJltfzoJJr1GSGixGTgkU8mn8jPg6Clvugdqo9
         TFK9Zc2mxtNRpbzIh4b0mtgXLiTjZmRqlT6FN9b0c11fqq3UGGvWb2amvkVjxRM/4bbP
         DriA==
X-Gm-Message-State: AOAM530XdZ3+fI6RnuhjULETdQtacKcX6fWgqzPG3IDgnFC4LqwrEAHD
        gDvaogdTSZaAj7/3hZZr8yVILA==
X-Google-Smtp-Source: ABdhPJyiiccrnWius1BWTgJTa5HN7sJBk331iM3iM9Jv7+uIfjVeO2PjkPDHGJ4ZwPFA89JxLPZ6Rg==
X-Received: by 2002:a62:8fcb:: with SMTP id n194mr4258239pfd.29.1643313782059;
        Thu, 27 Jan 2022 12:03:02 -0800 (PST)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id s2sm20501253pgf.56.2022.01.27.12.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:03:01 -0800 (PST)
Subject: [PATCH] RISC-V: Prevent sbi_ecall() from being inlined
Date:   Thu, 27 Jan 2022 11:55:55 -0800
Message-Id: <20220127195554.15705-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, aou@eecs.berkeley.edu,
        anup@brainfault.org, Atish Patra <atishp@rivosinc.com>,
        jszhang@kernel.org, vincent.chen@sifive.com, sunnanyong@huawei.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

The SBI spec defines SBI calls as following the standard calling
convention, but we don't actually inform GCC of that when making an
ecall.  Unfortunately this does actually manifest for the more complex
SBI call wrappers, for example sbi_s, for example sbi_send_ipi_v02()
uses t1.

This patch just marks sbi_ecall() as noinline, which implicitly enforces
the standard calling convention.

Fixes : b9dcd9e41587 ("RISC-V: Add basic support for SBI v0.2")
Cc: stable@vger.kernel.org
Reported-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
This is more of a stop-gap fix than anything else, but it's small enough
that it should be straight-forward to back port to stable.  This bug has
existed forever, in theory, but none of this was specified in SBI-0.1
so the backport to the introduction of 0.2 should be sufficient.
No extant versions OpenSBI or BBL will manifest issues here, as they
save all registers, but the spec is quite explicit so we're better off
getting back in line sooner rather than later.

There'll be some marginal performance impact here.  I'll send a
follow-on to clean up the SBI call wrappers in a way that allows
inlining without violating the spec, but that'll be a bigger change and
thus isn't really suitable for stable.
---
 arch/riscv/kernel/sbi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index f72527fcb347..7be586f5dc69 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -21,6 +21,11 @@ static int (*__sbi_rfence)(int fid, const struct cpumask *cpu_mask,
 			   unsigned long start, unsigned long size,
 			   unsigned long arg4, unsigned long arg5) __ro_after_init;
 
+/*
+ * This ecall stub can't be inlined because we're relying on the presence of a
+ * function call to enforce the calling convention.
+ */
+noinline
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
-- 
2.34.1

