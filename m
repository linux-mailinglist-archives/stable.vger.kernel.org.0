Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB43F4EF196
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348016AbiDAOhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347310AbiDAOc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC111EA286;
        Fri,  1 Apr 2022 07:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E63AB8240E;
        Fri,  1 Apr 2022 14:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31DC2BBE4;
        Fri,  1 Apr 2022 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823320;
        bh=fnYaDxJ7uaS/SP7Ui3FGqO635IVj63CD0EGocJ9Mak8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrWWR30Aec1Hrbu5U4bxnxvQRrwX63FeyYxROo+F62Vwt3Sj7RnN5hLwK2HslKDrI
         riEp3JEUbc0TzPHqfJVhqsUSZu71yVvuMpPpkXnY1jfUHWGDsZVsBx+Gf6hz4GC/OR
         dolgr26vfKfWz2VOQMGJrusyjmSOojpx1q4FfgH+6lL1oQ63fgcnAOhQlGPuA7dVA7
         NX1Uwl/mc/pqpLbI0l2bLZNPPHKM/hUPA1q13ec+yRNUcrTJDBaSgXcvIqmEQu61bq
         2h5KTvqFZJWSzzSeIO/oaED3g/NDvpuUHxRNbnJmfVBC0sefoV9RZYzR1Z206SVPt2
         7G/Ruz8ZlK29A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pbonzini@redhat.com, shuah@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 056/149] kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()
Date:   Fri,  1 Apr 2022 10:24:03 -0400
Message-Id: <20220401142536.1948161-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.34.1

