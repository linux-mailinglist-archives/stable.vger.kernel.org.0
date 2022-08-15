Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB01595057
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiHPEl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbiHPEju (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0E617B00C;
        Mon, 15 Aug 2022 13:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3C661072;
        Mon, 15 Aug 2022 20:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CAC433C1;
        Mon, 15 Aug 2022 20:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595605;
        bh=eSyVbOiJThicFPpIwquYb7vK65+7GU6j6F/FuNbE3hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znBoKjZlPLtBFHQ5HdC3Qd7TXwKQ23xhKEBTPfBnifc2YvgE0DkCJfKvqeeJCxOtT
         lbRAo/3XXNLq2Mnk8SPbNajl+5rQvekNbRQ7YDYwKjWj4UWOEx55uFFvD3nPbq87i6
         OtbIy8qvIlvP7J8voTo5yDleji2iHuO74rwEsEeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuad Tabba <tabba@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0817/1157] KVM: arm64: Fix hypervisor address symbolization
Date:   Mon, 15 Aug 2022 20:02:53 +0200
Message-Id: <20220815180512.169696319@linuxfoundation.org>
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

From: Kalesh Singh <kaleshsingh@google.com>

[ Upstream commit ed6313a93fd11d2015ad17046f3c418bf6a8dab1 ]

With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve incorrectly
from kallsyms. Fix this by adding the KASLR offset before printing the
symbols.

Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
Reported-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220715235824.2549012-1-kaleshsingh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index f66c0142b335..e43926ef2bc2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -347,10 +347,10 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)panic_addr);
+					(void *)(panic_addr + kaslr_offset()));
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)panic_addr);
+				(void *)(panic_addr + kaslr_offset()));
 	}
 
 	/*
-- 
2.35.1



