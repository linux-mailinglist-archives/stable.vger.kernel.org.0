Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348BB4EF03D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbiDAOe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347389AbiDAOcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9711957B20;
        Fri,  1 Apr 2022 07:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28E8AB8250F;
        Fri,  1 Apr 2022 14:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F062C340EE;
        Fri,  1 Apr 2022 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823315;
        bh=++ZMjef2Bu+3ZlLA/4YbvSkJqgM7tr0bCiofyxAxu8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jp0m5nTO1U+2u9ZJ07IAEPjWzh3wjvqNZ0nFwqZuJOKUiNbgMZV/xQkFApUZJN3Jy
         4Fogs7FX0sR8e5O2rvw/rMjGgbXskJwa3hWhY80ETpz97BxO7r7Yl2jkWQ7t0eZf9t
         5vs6AnLAgQaC0ZgtZaF+lqB7OiH2CnbvOolL2h4Ek7gEvJLLEB/+5pfCvpyhLnV13k
         nm6EMsPtDP3ccKczTvMFIVPtmWDgf0bXTUYPLhTHTODVVQQNRRGUKUPEm7c2FmZpuF
         MwwndBcPm5nJhtdavdPERFEoaCzNavcMZiWDSdJ+N3sO9enGbt8FNtqge4ioY2WenG
         j0gaMtPXUh1Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pbonzini@redhat.com, shuah@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 054/149] kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
Date:   Fri,  1 Apr 2022 10:24:01 -0400
Message-Id: <20220401142536.1948161-54-sashal@kernel.org>
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

[ Upstream commit 5b7898648f02083012900e48d063e51ccbdad165 ]

kvm_set_gsi_routing_irqchip_check(expect_failure=true) is used to check
the error code returned by the kernel when trying to setup an invalid
gsi routing table. The ioctl fails if "pin >= KVM_IRQCHIP_NUM_PINS", so
kvm_set_gsi_routing_irqchip_check() should test the error only when
"intid >= KVM_IRQCHIP_NUM_PINS+32". The issue is that the test check is
"intid >= KVM_IRQCHIP_NUM_PINS", so for a case like "intid =
KVM_IRQCHIP_NUM_PINS" the test wrongly assumes that the kernel will
return an error.  Fix this by using the right check.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-4-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 7f3afee5cc00..48e43e24d240 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -573,8 +573,8 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 		kvm_gsi_routing_write(vm, routing);
 	} else {
 		ret = _kvm_gsi_routing_write(vm, routing);
-		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
-		if (intid >= KVM_IRQCHIP_NUM_PINS)
+		/* The kernel only checks e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS */
+		if (((uint64_t)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
 				"error: rc: %i errno: %i", intid, ret, errno);
-- 
2.34.1

