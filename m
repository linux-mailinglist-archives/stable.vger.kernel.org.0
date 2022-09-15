Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6836B5BA03E
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIORJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 13:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIORJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 13:09:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B3F8C447
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 10:09:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id go6so14207579pjb.2
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 10:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:from:to:cc:subject:date;
        bh=MzjLsWwsMEvtVQwS3kea8WISTV/FriCydKOmRGB4teU=;
        b=xBwIfRQwAA1eeHVGn7Gle9nSvFHhulkm1NHZ4qEpV5c7x7QEpLApvpCnGDi8X+teXp
         PHXl9LYJhxBPWdDPbKAKXk5gBRvEXCIK0QwmuhCn3NbRynz4tDFk4lsQGaojbZ6xXH0P
         4Qx8uZUcVIwZO/obdevZ56NoGnrLU5hLUeuh8G4Nn7S8bAx52raNF5AwrWAHbmih0ATW
         yJ1pBkTGtMTzhxyuyYwSq6MUm0RNJAsR7sHpb3Dj9B9C4RhGdqvHBowZhZgZvlvGcwxR
         Cakye7NL3OKGLRkWJTR+w+pjlVBVkjE70S+bJ7J45RinxpbOXXaahtIoXw6xyXt2jGZ/
         dMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:x-gm-message-state:from:to:cc:subject:date;
        bh=MzjLsWwsMEvtVQwS3kea8WISTV/FriCydKOmRGB4teU=;
        b=ah7A/dBtl3PQjCyDDlCqIPWmxraNE5Zzm9GWr22Ch2teXlX+xceEkkc6kca48HDsXY
         TbWL7p25KMJBH9ByzBcS0DkeP+H+HqWVAi+ZUflOvbWvle3Gn4iCJeVpvaJ0/7WwLDeE
         knzkVx0/YA8Lk675/ruNg7Oxtsh4Zas9pGulQe71KO78/Nmp0EE+TG2Ms4a27y08QZDW
         Frw7wnDmTZBJTolf9pSLf59Y9NR60Ip0yzeqL7Rcid/rK3UOfTj8Rohb0UccKsz5BJXr
         MK/Z/TKXrwHB0vVhOqUlsL2MRSvsEQq6tl+ISsMq2KSqCgRauU0Yw6JMSvrRIC8TuBGd
         qvHg==
X-Gm-Message-State: ACrzQf0bDp5N+ReMxM2n1CN55Lsq3nAdjWiW4lwGnc5RSjLXeTPoeGjC
        EaaInpYM3KPUTYTh5Fcs/hk7Ag==
X-Google-Smtp-Source: AMsMyM586KF92oK5VWTnmlyZ9k5mOf2fCMkYo84u76aDioKF8pkhbfbU6NiVoAEeRNESc8fpl28SKA==
X-Received: by 2002:a17:90a:243:b0:200:80ea:a6f3 with SMTP id t3-20020a17090a024300b0020080eaa6f3mr11846063pje.9.1663261753546;
        Thu, 15 Sep 2022 10:09:13 -0700 (PDT)
Received: from localhost ([172.58.30.147])
        by smtp.gmail.com with ESMTPSA id 72-20020a62174b000000b0053eec4bb1b1sm12657540pfx.64.2022.09.15.10.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 10:09:13 -0700 (PDT)
Subject: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Date:   Thu, 15 Sep 2022 10:09:00 -0700
Message-Id: <20220915170900.22685-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Conor Dooley <conor.dooley@microchip.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:         linux-riscv@lists.infradead.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We could make the T-Head CMOs depend on a new-enough assembler to have
Zicbom, but it's not strictly necessary because the T-Head CMOs
circumvent the assembler.

Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/include/asm/cacheflush.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index a89c005b4bbf..273ece6b622f 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -42,8 +42,12 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
 
 #endif /* CONFIG_SMP */
 
-#ifdef CONFIG_RISCV_ISA_ZICBOM
+/*
+ * The T-Head CMO errata internally probe the CBOM block size, but otherwise
+ * don't depend on Zicbom.
+ */
 extern unsigned int riscv_cbom_block_size;
+#ifdef CONFIG_RISCV_ISA_ZICBOM
 void riscv_init_cbom_blocksize(void);
 #else
 static inline void riscv_init_cbom_blocksize(void) { }
-- 
2.34.1

