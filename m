Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7868F5938AA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343649AbiHOTMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344143AbiHOTLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA1150188;
        Mon, 15 Aug 2022 11:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6D866113C;
        Mon, 15 Aug 2022 18:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF8CC4314B;
        Mon, 15 Aug 2022 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588635;
        bh=XaMbj9V8F6cyjECBekjmkj0GXiceZTtqfdngt5Y36Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZV4FbM4ENjF7vSQCfyutLbQAf6JlnATwPA1XE6KisXZuIecQ/EIFrjhPj0PvVq2y
         ijtreCzYRjoMm6AVvYI6qaQQb1e7iPBpfezj701wefV9OIzT09Xmjkxkh3EVDMEWQe
         TlfUwMZs2zCJOJEGM5HWnpStSkyhOLa2cxMNwzro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 467/779] KVM: arm64: Dont return from void function
Date:   Mon, 15 Aug 2022 20:01:51 +0200
Message-Id: <20220815180357.260035085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index a34b01cc8ab9..4db5409f40c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -279,5 +279,5 @@ void __noreturn hyp_panic(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d88d3c143a73..813e6e2178c1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -220,5 +220,5 @@ void __noreturn hyp_panic(void)
 
 asmlinkage void kvm_unexpected_el2_exception(void)
 {
-	return __kvm_unexpected_el2_exception();
+	__kvm_unexpected_el2_exception();
 }
-- 
2.35.1



