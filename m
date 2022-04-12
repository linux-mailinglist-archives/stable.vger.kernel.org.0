Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E984FD751
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356554AbiDLIKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357093AbiDLHjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FB79FC8;
        Tue, 12 Apr 2022 00:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F35616E7;
        Tue, 12 Apr 2022 07:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F1CC385A1;
        Tue, 12 Apr 2022 07:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747501;
        bh=Msr4Gq3pyulIUEyqR8XNczKHQK4bAvQ9hTJeI+N2L84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csbulciRzku8ISBLutWHHcyr1LLb7Pnc5Iaa/SLLyNTaX/1CRT3jK123MTvlVBFe3
         QEtpwC/NMBjtVI8P9NqkwFL6kUcU7EY5SflAP9LWOvYeSdeCd+qqQ2q1ie4KlptOGr
         19NO/IefEEsyUe9pMXcJt1py6I/XJ8c8f2q4HSlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 065/343] kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()
Date:   Tue, 12 Apr 2022 08:28:03 +0200
Message-Id: <20220412062952.980826571@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit b53de63a89244c196d8a2ea76b6754e3fdb4b626 ]

vgic_poke_irq() checks that the attr argument passed to the vgic device
ioctl is sane. Make this check tighter by moving it to after the last
attr update.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-6-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 7c876ccf9294..5d45046c1b80 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -140,9 +140,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	uint64_t val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
-	/* Check that the addr part of the attr is within 32 bits. */
-	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
-
 	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
 					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
 
@@ -152,6 +149,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
+	/* Check that the addr part of the attr is within 32 bits. */
+	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
+
 	/*
 	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
-- 
2.35.1



