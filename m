Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536BD582EC9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241724AbiG0RQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiG0RQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:16:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29CF5C950;
        Wed, 27 Jul 2022 09:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD4E601CE;
        Wed, 27 Jul 2022 16:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAB9C433D6;
        Wed, 27 Jul 2022 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940185;
        bh=SVt23Q0d84gwrhaqA8w8sNWD9r1w9t4co/Eki16M7MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlTcmQhNBvC+AHzLzg80H6GbQwxRE7bkhyh9v9jWK3LWdzIYtcJSMsq9uemWxpZRB
         C4N+ck4MdD/Q6htQ1nz30NN5L02Qtyg+6s3ir6jK6R7oiksN7TSuH9gPrncH71s5jG
         tQQ98FOQsghUHx44HaX5s2QedkS5yLC7rgf6OuxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 5.15 134/201] KVM: Dont null dereference ops->destroy
Date:   Wed, 27 Jul 2022 18:10:38 +0200
Message-Id: <20220727161033.348145340@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit e8bc2427018826e02add7b0ed0fc625a60390ae5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4172,8 +4172,11 @@ static int kvm_ioctl_create_device(struc
 		kvm_put_kvm_no_destroy(kvm);
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
 


