Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060165F30DD
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiJCNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiJCNMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:42 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7394DF24;
        Mon,  3 Oct 2022 06:12:32 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2E7FF42FB7;
        Mon,  3 Oct 2022 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802728;
        bh=WkO8+eonbZ1MoHOI1IZGv5m0nOusRYuhgSmZ4TsmYis=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Ye7UOUAqvXx91H+Af+lG01KvfuNYJ3w57i/AQzBtdAYYgT64QFvPjPKTFcSbrHsC+
         QjB3wlZN0ItK7Mv8wNN0eVDFo+UuAh/Goo8iKmlIctokZ0iL/vtQagy8nQtRA/+qpP
         MYq0eIeN1a5X0WKN7ra8CgIJVbrj911Kq8U1EmhnV76RhDV6HNr64JWtpsKzcCS3fQ
         PsyJ+PJ2deMrDWPk/9OKVZsLJL4v34PSXphwRGh1D0WkgAiUcoeEW7VyYLABHYcYpk
         H1SJlawjXyZvQj/vmveVhWivKMGjanay42M/acc1rlhi14fCSijGfJIVIwRp0sU26P
         +6zlMobUc1Lwg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 20/37] x86/speculation: Fix firmware entry SPEC_CTRL handling
Date:   Mon,  3 Oct 2022 10:10:21 -0300
Message-Id: <20221003131038.12645-21-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit e6aa13622ea8283cc699cac5d018cc40a2ba2010 upstream.

The firmware entry code may accidentally clear STIBP or SSBD. Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/nospec-branch.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index b7201f24796c..3c78a1b3451c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -307,18 +307,16 @@ extern u64 spec_ctrl_current(void);
  */
 #define firmware_restrict_branch_speculation_start()			\
 do {									\
-	u64 val = x86_spec_ctrl_base | SPEC_CTRL_IBRS;			\
-									\
 	preempt_disable();						\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
 do {									\
-	u64 val = x86_spec_ctrl_base;					\
-									\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current(),			\
 			      X86_FEATURE_USE_IBRS_FW);			\
 	preempt_enable();						\
 } while (0)
-- 
2.34.1

