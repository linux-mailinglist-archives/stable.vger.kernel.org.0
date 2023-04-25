Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8266EE1AB
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjDYMMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDYMMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 08:12:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0F54EE2
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 05:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC2D61DCE
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 12:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47A0C433EF;
        Tue, 25 Apr 2023 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682424762;
        bh=vR9XcsNW63+rWPb21+gVYW6eOEhg8GX7COAjWtaB7WQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qZ/OwaEEC/m5QjdKhjeu35+kgP2I5dG8J16AO4o1DWzo1GoDMtPWpSWWGPgRu+IyN
         9jvImYLy+iSkr/gcvq2uOv9CEL3SaTTcTSLRFH8nso1eMyg6hzuSOW3ugev7/MjyDy
         bczNwuUyVy7Zy0ohgD+mxLmBUfIgIdjkEKLxq3WmVjpx1ChhwF6nghUKOyq7oO/ohA
         i3AcTSRQ/a0yJNWQGgJLGgjPsYbWy33cqPbHzhSXC+qkPL1j0+dspQ5ETIwXGufe6P
         5mUaClfyxyfzCKHajob0x/6l/JRPgBraMKfX8sLNzfMbz/mI1APSsF4m1oa+/UiggB
         UKx/Doia0g73w==
From:   Will Deacon <will@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kvmarm@lists.linux.dev,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Steven Price <steven.price@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>
Subject: [BACKPORT PATCH 5.10.y] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Date:   Tue, 25 Apr 2023 13:12:36 +0100
Message-Id: <20230425121236.8364-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a25bc8486f9c01c1af6b6c5657234b2eee2c39d6 ]

The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
between 0-32768 but if it is more than sizeof(long) this will corrupt
memory.

Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Cc: stable@vger.kernel.org # 5.10 and 5.15
[will: kvm_arm_set_fw_reg() lives in psci.c not hypercalls.c]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/psci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 20ba5136ac3d..32bb26be8a9b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -499,6 +499,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-- 
2.40.0.634.g4ca3ef3211-goog

