Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C5D54A6A8
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355243AbiFNCcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356842AbiFNCbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DC54474F;
        Mon, 13 Jun 2022 19:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0BBEB816AA;
        Tue, 14 Jun 2022 02:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA064C3411E;
        Tue, 14 Jun 2022 02:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172745;
        bh=QPq4A+MPT7ODraj38T+gaiAyBRab/RGhAAvnfWnRn0M=;
        h=From:To:Cc:Subject:Date:From;
        b=YIJ8DM+GKq8jv8n8PMPgZOX8E5loTjw2ghHuQWZ8UQp1p+BoRjdmXhWjF7WElibg7
         VZn8ErmHCmo9NCC0uO8f5W8ebr66fnvInUDTbxvgAN+PQeZ0XdPHwLZ6E2ESoF49A4
         fmYEbklY8U67bG3wM5+7abGIpC4ARijk10w1HuCnCmuIUXNi19iZ+P7txZBpNA3nlH
         b5lkRcLFsYD9XVpydyk/OMLsN8Xn+6ZMUVh3LYwnouiaOyT8zV9PsTsbBRXdHJ3tcK
         h3EMKY28goqq0BocBbjMFvMPnsXwyn1wzMYS8Alc4neOMVVyd+9fqsDhnm+2aFrn3S
         UelS4HDbksj8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 4.9] KVM: Don't null dereference ops->destroy
Date:   Mon, 13 Jun 2022 22:12:07 -0400
Message-Id: <20220614021207.1101649-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit e8bc2427018826e02add7b0ed0fc625a60390ae5 ]

A KVM device cleanup happens in either of two callbacks:
1) destroy() which is called when the VM is being destroyed;
2) release() which is called when a device fd is closed.

Most KVM devices use 1) but Book3s's interrupt controller KVM devices
(XICS, XIVE, XIVE-native) use 2) as they need to close and reopen during
the machine execution. The error handling in kvm_ioctl_create_device()
assumes destroy() is always defined which leads to NULL dereference as
discovered by Syzkaller.

This adds a checks for destroy!=NULL and adds a missing release().

This is not changing kvm_destroy_devices() as devices with defined
release() should have been removed from the KVM devices list by then.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d251b718bf53..5482f47cb07d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2995,8 +2995,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		kvm_put_kvm(kvm);
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
+		if (ops->release)
+			ops->release(dev);
 		mutex_unlock(&kvm->lock);
-		ops->destroy(dev);
+		if (ops->destroy)
+			ops->destroy(dev);
 		return ret;
 	}
 
-- 
2.35.1

