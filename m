Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57CE59505A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiHPEl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiHPEkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF58A4B31;
        Mon, 15 Aug 2022 13:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4DFFB8119B;
        Mon, 15 Aug 2022 20:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E29C433C1;
        Mon, 15 Aug 2022 20:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595485;
        bh=vQ2/zyOfEfBMsBJ73rlM/AGZYeVGuBcIjrR4csaKKhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mr2cMJOjoHouPzNi15mEJJ5YtsXSdFz+3aMudZV7h3e4hD5gFPQbLjae2MWkMxbc4
         mXX6zMycl5tVbOzxczB8nLJ9exZniuLV6udertqwt9wPzLwP5dut9/GorLX54/1vbZ
         mOithi055eYYOh0B2vlzDMXScjW/SbGyycHucHfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0779/1157] KVM: arm64: Dont return from void function
Date:   Mon, 15 Aug 2022 20:02:15 +0200
Message-Id: <20220815180510.659910969@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Perret <qperret@google.com>

[ Upstream commit 1c3ace2b8b3995d3213c5e2d2aca01a0577a3b0f ]

Although harmless, the return statement in kvm_unexpected_el2_exception
is rather confusing as the function itself has a void return type. The
C standard is also pretty clear that "A return statement with an
expression shall not appear in a function whose return type is void".
Given that this return statement does not seem to add any actual value,
let's not pointlessly violate the standard.

Build-tested with GCC 10 and CLANG 13 for good measure, the disassembled
code is identical with or without the return statement.

Fixes: e9ee186bb735 ("KVM: arm64: Add kvm_extable for vaxorcism code")
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220705142310.3847918-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6db801db8f27..925b34b7708d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -386,5 +386,5 @@ asmlinkage void __noreturn hyp_panic_bad_stack(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 969f20daf97a..390af1a6a9b4 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -249,5 +249,5 @@ void __noreturn hyp_panic(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
-- 
2.35.1



