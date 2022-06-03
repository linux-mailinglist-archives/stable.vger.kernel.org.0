Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077C553D09C
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiFCSHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbiFCSEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:04:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E135712F;
        Fri,  3 Jun 2022 10:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366A5B82189;
        Fri,  3 Jun 2022 17:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FB2C385B8;
        Fri,  3 Jun 2022 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279025;
        bh=wTV5cVFc5rKLzg7MqcEFuVDlN6PsOXkUdWpdiX9W7qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLDvkMc/Bq4S5SvdIZCQ4GpGJxuUhdFFKrMHdTxTokL/G9HZ3MYKRK1sJgtt60Hga
         qMJbc6vmDaov765QYnsRTe9GuHHCMkffsGFlDxaBte99WHRXu9oPUiOb+44u9MaiUM
         gZUT/veLR3/hG1A/vChceoU2IRHPbeyU4ugirBtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 28/67] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak
Date:   Fri,  3 Jun 2022 19:43:29 +0200
Message-Id: <20220603173821.535586563@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

commit d22d2474e3953996f03528b84b7f52cc26a39403 upstream.

For some sev ioctl interfaces, the length parameter that is passed maybe
less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
that PSP firmware returns. In this case, kmalloc will allocate memory
that is the size of the input rather than the size of the data.
Since PSP firmware doesn't fully overwrite the allocated buffer, these
sev ioctl interface may return uninitialized kernel slab memory.

Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: eaf78265a4ab3 ("KVM: SVM: Move SEV code to separate file")
Fixes: 2c07ded06427d ("KVM: SVM: add support for SEV attestation command")
Fixes: 4cfdd47d6d95a ("KVM: SVM: Add KVM_SEV SEND_START command")
Fixes: d3d1af85e2c75 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Fixes: eba04b20e4861 ("KVM: x86: Account a variety of miscellaneous allocations")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Message-Id: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -688,7 +688,7 @@ static int sev_launch_measure(struct kvm
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -808,7 +808,7 @@ static int __sev_dbg_decrypt_user(struct
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
@@ -1094,7 +1094,7 @@ static int sev_get_attestation_report(st
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -1176,7 +1176,7 @@ static int sev_send_start(struct kvm *kv
 		return -EINVAL;
 
 	/* allocate the memory to hold the session data blob */
-	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	session_data = kzalloc(params.session_len, GFP_KERNEL_ACCOUNT);
 	if (!session_data)
 		return -ENOMEM;
 
@@ -1300,11 +1300,11 @@ static int sev_send_update_data(struct k
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
-	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	hdr = kzalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
 	if (!hdr)
 		goto e_unpin;
 
-	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	trans_data = kzalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
 	if (!trans_data)
 		goto e_free_hdr;
 


