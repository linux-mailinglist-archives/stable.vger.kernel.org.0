Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452AC6EBE95
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 12:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDWKZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 06:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWKZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 06:25:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284410D9
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 03:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5666160BFB
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 10:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509D5C433EF;
        Sun, 23 Apr 2023 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682245552;
        bh=st7OVZ4n+miEk+m6SRSdNFJVE2tTnNeFszvsvCTx3dk=;
        h=Subject:To:Cc:From:Date:From;
        b=sSHbHhOd29VTErfTOGlNrmhBE+GqNKYg0dJKaRqQLEASWMxV9QmKFT0kSpd0xbMzD
         L51psEn7RNPWOJU4VTabYwnoVbycRt1ssuFxZoHKy+CElsFUwd8mSNGeCGVEDofhZE
         P1eRK8TT66XqiPwS8U8zUr9IXqOLBCzgOrxtsiV4=
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()" failed to apply to 5.15-stable tree
To:     dan.carpenter@linaro.org, eric.auger@redhat.com, maz@kernel.org,
        oliver.upton@linux.dev, steven.price@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Apr 2023 12:25:49 +0200
Message-ID: <2023042349-cackle-parasite-ff0b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x a25bc8486f9c01c1af6b6c5657234b2eee2c39d6
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042349-cackle-parasite-ff0b@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

a25bc8486f9c ("KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()")
85fbe08e4da8 ("KVM: arm64: Factor out firmware register handling from psci.c")
1ebdbeb03efe ("Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a25bc8486f9c01c1af6b6c5657234b2eee2c39d6 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@linaro.org>
Date: Wed, 19 Apr 2023 13:16:13 +0300
Subject: [PATCH] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()

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

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5da884e11337..c4b4678bc4a4 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -397,6 +397,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 

