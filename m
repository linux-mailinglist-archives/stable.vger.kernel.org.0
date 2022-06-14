Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0B454A6F2
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353410AbiFNCjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356815AbiFNCi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF5038A;
        Mon, 13 Jun 2022 19:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2D4FB816A4;
        Tue, 14 Jun 2022 02:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A161FC34114;
        Tue, 14 Jun 2022 02:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172721;
        bh=LijSy99pzpSg1iIzbzqZJpsUfznU587YrJg1vozHGAU=;
        h=From:To:Cc:Subject:Date:From;
        b=E+5fKuEZIB96bHfxsYSBfHd9fzJFDKPBSV8/2W4MZIw1UyYWGtqmkxWWDoeByOQp/
         xQDfQreHaxLSnPMT6fnHeeyNo5UargrYKS3sUg1cq1yeOD/YxHX5rMd4X+lDEs1Rnt
         zegqaxX9NF7s4w8Do4vwZx+lbohIYghnbFMfAKfkpKqVVMgMoLCEs/Zc2BbG8h0PDj
         m8G99syV6P8cajGtUOW1aeJWRV1zqqyPktwJgVouau9RZl2iwSBfTZoBb1NjULz5hT
         r+MG8d0875byGrOd9yazltRttmhGQNk7djBdw7lheQyArfs9hQBSUXn/NGbGDafkFq
         c6cD/9diTwEtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4] KVM: Don't null dereference ops->destroy
Date:   Mon, 13 Jun 2022 22:11:58 -0400
Message-Id: <20220614021158.1101574-1-sashal@kernel.org>
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
index 287444e52ccf..4b445dddb798 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3329,8 +3329,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
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

