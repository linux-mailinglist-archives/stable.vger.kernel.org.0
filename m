Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B1C6035EB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 00:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJRWd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 18:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJRWdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 18:33:21 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E581B3B23
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 15:33:21 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id p7so16178541vsr.7
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 15:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CadBqoM6bifDpNUdEdKIKRDcKPRD8gQysiN/wdlQYGc=;
        b=UcoNpkjlb8TjzV+AbCpUVWfRwYTHnn9zpi0/D11HZPn0408rL+a20gmWFBANT8NhFW
         B2ImtHs5lDsOnlY6uhayWt/NitQIen3+75t7x2NMeK7JcpSW5oaZchk8YgyC6JE8nQnn
         5by/rWootgNcnSXiXyv4zxpMoy1hzpbgkSpHuf1FIo0Qfbewc8Bqcm3swY33Fgeuu0xA
         59+I8WYLBYxwWTKxMcYJRvgCezbd35qq2O8u3rJ/RvitqZJ+LAXw7tbZpNc3d2ijNV3A
         LQIQymXD9KtSfXsGNmU3VgD6aqT+bcFpKUijkYerQC1w/uOORq4QeML+s9da170SXI6t
         +m7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CadBqoM6bifDpNUdEdKIKRDcKPRD8gQysiN/wdlQYGc=;
        b=azyVgakmHhLMoN3zDJlBUCDRST1ToHYJKqrp9rY/3E7TKfNcXBsiByVEqXG0xXC6U/
         MTMpSieD+4OkZk/KEOP3L5k68F00dSZfS0H4KN1FvnxYo6b3dfKSO5mjk+LIr707M1e2
         ACHMq14SKZcNvOfVbXuWLb0KIHI7j6eDOgXcSdzNtkKyVsfvaG7bqFAaammicOwFjxZH
         9dVQIWjAInLAmitkuzsj+OxIuAO+GDYHqOOPo3Lk/m7d5G8+4/7sG0nUkNo8tef44irD
         kmpK8X2cgi7T6bMOnRfC30mCM/l3i5Lb/xXKWLuf+KjQ+AjAcMW1bws9b7CqFYI99U/F
         zuVA==
X-Gm-Message-State: ACrzQf3Di5RzuBgbixfY6JzqKKxH2Zs4sp58j7MOHlNWUS6j24B9mo3Y
        9XuU38If6CyxSB8DzmoGv0vpOypVI2Crwo24/cXiTrfmKS7GzQ==
X-Google-Smtp-Source: AMsMyM6YodMSoR+Gyx8Y3+VKeVPmy1ept9f6N676drLGyVZJUF7jBTLXGq8d5SthraScIUwdIELb+KKdLuv6D2HhYZU=
X-Received: by 2002:a05:6102:3172:b0:3a7:319c:ffef with SMTP id
 l18-20020a056102317200b003a7319cffefmr3051912vsm.80.1666132399913; Tue, 18
 Oct 2022 15:33:19 -0700 (PDT)
MIME-Version: 1.0
From:   Evgenii Stepanov <eugenis@google.com>
Date:   Tue, 18 Oct 2022 15:33:08 -0700
Message-ID: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
Subject: backport of arm64: mte: move register initialization to C
To:     stable@vger.kernel.org
Cc:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable,

please backport the following commits to 5.15-stable:

commit 973b9e37330656dec719ede508e4dc40e5c2d80c upstream.

Please note that the extra backport below can be avoided with a
trivial change in the above patch. Let me know if that's preferable.

Cc: <stable@vger.kernel.org> # 5.15.y: e921da6: arm64/mm: Consolidate
TCR_EL1 fields
Signed-off-by: Evgenii Stepanov <eugenis@google.com>
