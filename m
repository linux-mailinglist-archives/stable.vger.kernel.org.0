Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70076ED096
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDXOsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjDXOsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:48:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43C55FFD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:48:03 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f1950f5628so32763245e9.3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682347681; x=1684939681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=daikW0npmBIZWsOHPEIOIMHMXTfkcPibtLpJISnoizA=;
        b=OT9XlQt6odGrTQWHGzVf7/R8/MupiWjcAvdwNZ+gDIxDfEzDqbS/tNeVKcw6sypTRv
         IEpcL5z45MKzFFwPzLAlLRfUavYTmhMn4xWk3CoRgo1RVSRKJWwV6K8HIka5C1IjNFUg
         lOgGHxjABZ+5Cp5fgQ90WYgyQjDGYMjA4bEZvDFBXaddOuCV1tUrU4UgntIRMNs12VtZ
         Vzb8NGhFAe1oEvoFVxF07RJOPq5e7TteFdF7CQBFVtZVfmzkDLQLPcJMDOlZ3HFRGEcK
         NMGYP4PMjrf1I8vOW4u8+9KRdlr6nnCp+FT5fLL0e5nWWdtldw1D6w+ITByUODy7u693
         FsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682347681; x=1684939681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daikW0npmBIZWsOHPEIOIMHMXTfkcPibtLpJISnoizA=;
        b=Xq5yp/CxhnP3YjkjcnfLugIUOl06dbgA/xyWmRULtXOpEp5ETetdWtrRsTybf0/FxY
         /dQVQdZHHIsVxwk0YZHVBwptYL5Q1naTj7N1ud3Eb9g/v0pgxPdBQozhh2avGGVbReJE
         G33poNxWjy6fN6L5kITVwh2tObDxOx30IqBLoXwWYPoFSUE7QXCpmfjZDg3PzQ8lIsgV
         lRPax17QrP3SKjVuS8Otj6gROnwdfy0ItRiRXXGfrd3mdEmBbVcVS1VIT7F9UOx47AdE
         dC6YsLlDl3Cxojj4VQTEeKJq7Ncugj/hMjQtAUgeek4dusUu0rNoM/bh01f67CeHwEPN
         yRhQ==
X-Gm-Message-State: AAQBX9de7JONf34BB+Lj0pHh3WoUrXcbVoilGBScNvbNzhYMGpObk2FY
        zqSvbvJIi4Bsn9sFFcGdedzhaQ==
X-Google-Smtp-Source: AKy350arq+PuErXN+aFcCT2Pn3bO6Ltd5/liplgZqj9SUMAT0Av+AW8pUtRe6VKX6wE0OryT05FCZg==
X-Received: by 2002:a5d:595b:0:b0:304:794c:732e with SMTP id e27-20020a5d595b000000b00304794c732emr3019482wri.41.1682347681563;
        Mon, 24 Apr 2023 07:48:01 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id g3-20020a5d5543000000b002fe254f6c33sm10895526wrw.92.2023.04.24.07.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:48:01 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 v2 0/3] Fixes for dtb mapping
Date:   Mon, 24 Apr 2023 16:47:34 +0200
Message-Id: <20230424144737.194316-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We used to map the dtb differently between early_pg_dir and
swapper_pg_dir which caused issues when we referenced addresses from
the early mapping with swapper_pg_dir (reserved_mem): move the dtb mapping
to the fixmap region in patch 1, which allows to simplify dtb handling in
patch 2.

base-commit-tag: v5.15.108

Changes in v2:
- Fix upstream commit line position

Alexandre Ghiti (3):
  riscv: Move early dtb mapping into the fixmap region
  riscv: Do not set initial_boot_params to the linear address of the dtb
  riscv: No need to relocate the dtb as it lies in the fixmap region

 Documentation/riscv/vm-layout.rst |  2 +-
 arch/riscv/include/asm/fixmap.h   |  8 ++++
 arch/riscv/include/asm/pgtable.h  |  8 +++-
 arch/riscv/kernel/setup.c         |  6 +--
 arch/riscv/mm/init.c              | 68 ++++++++++++++++---------------
 5 files changed, 52 insertions(+), 40 deletions(-)

-- 
2.37.2

