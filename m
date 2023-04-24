Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CF66ED0E5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 17:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjDXPEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 11:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjDXPED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 11:04:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D974161AB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:03:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-2f58125b957so4128272f8f.3
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 08:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682348638; x=1684940638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8RtY00JwyNkAtAmX5W3oxGMcQc/5Sznm9C0GKVvVNR0=;
        b=pVxqUcJjxIVeqJH87iZKy16smgEKzlKrFR1KhVut7HSJfSuchzzx+9smgWZ+wiDsyO
         NDyeAVTD21+i060248rYLw2TcqndLCSfvJAnw5wIRdJx4+IttSzjxE+lR4qRPs0whDkV
         KDJaK3eyPw2FUS6uyn2i2nLwo4jaJDgFXwLY3y1tG7vreZyEhGWiVqpfJsPMkqJwy7zY
         IrwT2zM4vsLVI4ku5AOSONAqaJdAxvBje3lPkUFZ5QWKhaWlmifoM+8ou0kAsdqmotXD
         xSJsfbyeEiQerAP5FZjATsT0K1ItiHkIAK3ysoS6X2eQqpyv51xo5FjYMUQMBc1s4Uzo
         2JVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682348638; x=1684940638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8RtY00JwyNkAtAmX5W3oxGMcQc/5Sznm9C0GKVvVNR0=;
        b=hqlBXwPpgaL79/TC42XOWPazCkMwtikmMW3Qkwi2GAWhpzF9WSfyhGA70JhXD/Gl4d
         Qk7CglCiHyV7AcSf1t5+Kxu4gzJY3O/cXwqUrSvVyHjf9judYBikFXQ/0oz8OGRuNaqm
         FZ8TzM6Usm8JR4F7CpiwkV86qOUlGbZWSnCGR+HFGhDxlWxepgdlvsoOiK+PgOtUYr2S
         6+gqhyV/KCGR9R/vZx3iu3lam6ycy7BjTAXBt1HVL3dlBXyqSLL0YEmwHnglvnlv90Mx
         NTce+v7oJ4wdz0+mPhfU7xmp4bQG5xlW1KofTwJyFywbSuo8AJ0ozC0lDqmcBjPjMCJF
         b5lA==
X-Gm-Message-State: AAQBX9fF0GKsIQmZ67VYmSJ64pyd3AX1yJeKOvHVesKGfju9TY0W+JNV
        o/5ktH7dvPF7z5Km6iMat+JUAg==
X-Google-Smtp-Source: AKy350ZD5Q+NIOLy42zuCrNbxsYHdQv8YbfOFgL1ekxCTgig5EEJ1Kpb6Dw+yCmQbW4IDEenz82LCA==
X-Received: by 2002:a05:6000:1c9:b0:2fe:2f01:fc7e with SMTP id t9-20020a05600001c900b002fe2f01fc7emr9281647wrx.13.1682348638298;
        Mon, 24 Apr 2023 08:03:58 -0700 (PDT)
Received: from alex-rivos.home (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id c4-20020adffb44000000b00304760c891asm3528099wrs.52.2023.04.24.08.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 08:03:57 -0700 (PDT)
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
To:     Conor Dooley <conor.dooley@microchip.com>, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH 6.2.11 0/3] Fixes for dtb mapping
Date:   Mon, 24 Apr 2023 17:03:51 +0200
Message-Id: <20230424150354.195572-1-alexghiti@rivosinc.com>
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

base-commit-tag: v6.2.11

Alexandre Ghiti (3):
  riscv: Move early dtb mapping into the fixmap region
  riscv: Do not set initial_boot_params to the linear address of the dtb
  riscv: No need to relocate the dtb as it lies in the fixmap region

 Documentation/riscv/vm-layout.rst |  6 +--
 arch/riscv/include/asm/fixmap.h   |  8 +++
 arch/riscv/include/asm/pgtable.h  |  8 ++-
 arch/riscv/kernel/setup.c         |  6 +--
 arch/riscv/mm/init.c              | 82 ++++++++++++++-----------------
 5 files changed, 54 insertions(+), 56 deletions(-)

-- 
2.37.2

