Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC636ECB9F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 13:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjDXL4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 07:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjDXL4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 07:56:24 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6CA3A9A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:56:22 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2f7a7f9667bso2587847f8f.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 04:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682337381; x=1684929381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pQU2g1kGkzdMFrX2k6b7eThbNuKIWvj0D4e8RKLMgu0=;
        b=Lf6EkpGS6in3w7bp80A9ylSR91e6gGlqzjp4CMJESIfEDy9MirkU0Ll2X6gXMxf+FY
         pKXkX2Yr+q8Cgk4lZ8mzl5fsIBoU7YRAXPFi4NfWjoiaWApXYdo/u181Z3wwpIWBKl04
         udymRQdnrmup64dfX6RZLgr4z6QukrJiSZGS2phXLgaD187JdExKW7Jc/BQ2cKV8+49/
         4ZklAFrwVtdBgJTYK5K3okrd0S54tbYxshnePYQtgyL/f8Eo4bSdE3iht9yMIbIfETtd
         UNSEBDec6sJjqD63o1XBzsCpHYBPFFHoxn57kBZ9kmcIg+gct3Wls7gQpfCdt7SNV1Yr
         C1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337381; x=1684929381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pQU2g1kGkzdMFrX2k6b7eThbNuKIWvj0D4e8RKLMgu0=;
        b=FRcJoYtHlzxvuNkPL54P4xwKGIc4dwt0tRBgJB8cxPhkdu6zNSj5+Pks5seKwdTPIZ
         Uswr+G3getNfCTRuEgbUhocBw/w8LpUJLJnZw75aJhuA4ALrkqypjVwMEgRrSjJBw5gV
         FJppmmLlSw4natH02IFAClZ/UoY0fN1Qv3WpPi9yIEM5QSfS4WYf1qCweDwsHxNL/eZc
         hBC6JqLbFvPyMBy+S9oF/nx+XvRJtrm8tP07MRbBNhyh8rPTZquyxXjlRVkVj0RLr4kj
         VyvPc/KS7Rc8hrMIJ9ub819BY2Rb3TtM9A/vJrV6zlTPm1UgpCd68ef4P4fjXu+LB3vF
         Tlew==
X-Gm-Message-State: AAQBX9cpjTvpXcropjEYHo7NJ9UlHxYWIuPsaWc9ymqjbfTtfacmPgEV
        MvKqE+6CWRrsqlGuZvZpKZIvHUMbA4VZkjh3TZI=
X-Google-Smtp-Source: AKy350Z9n8trlhkeIEs8ff7USM6+afN485iSAwQsrKiC4v7Pj0PQEH+fBo2YPMofLQfZcDeOMzIoSw==
X-Received: by 2002:adf:fe47:0:b0:2d0:d739:f901 with SMTP id m7-20020adffe47000000b002d0d739f901mr9207883wrs.20.1682337381073;
        Mon, 24 Apr 2023 04:56:21 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6892000000b002f9bfac5baesm10665254wru.47.2023.04.24.04.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 04:56:20 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 5.15.108 0/3] Fixes for dtb mapping
Date:   Mon, 24 Apr 2023 13:56:15 +0200
Message-Id: <20230424115618.185321-1-alexghiti@rivosinc.com>
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

Alexandre Ghiti (3):
  [ Upstream commit ef69d2559fe9 ]
  [ Upstream commit f1581626071c ]
  [ Upstream commit 1b50f956c8fe ]

 Documentation/riscv/vm-layout.rst |  2 +-
 arch/riscv/include/asm/fixmap.h   |  8 ++++
 arch/riscv/include/asm/pgtable.h  |  8 +++-
 arch/riscv/kernel/setup.c         |  6 +--
 arch/riscv/mm/init.c              | 68 ++++++++++++++++---------------
 5 files changed, 52 insertions(+), 40 deletions(-)

-- 
2.37.2

