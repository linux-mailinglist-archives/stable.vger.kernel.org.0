Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD957551B72
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347004AbiFTNkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347491AbiFTNik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D533D1F62C;
        Mon, 20 Jun 2022 06:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57CE961543;
        Mon, 20 Jun 2022 13:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD8FC3411B;
        Mon, 20 Jun 2022 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730235;
        bh=r4HTTZDPskHPPm1axn9xIWDD/skwl4wwe/Ur5YtpFjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/y31kxrrj2lrIXPcbwB81yjxm367j3EPpXDZWy/oWnrQlX+20amVFyAO9betY9sX
         mPf9KIbbkI2b7vEoAF1CLDK+sWEzJpnzkyktCjQVDQOTJuv0wsAZcYDN+9P6fHBSlR
         JQLBFEytijhnYO6iLUOue5Q00RhfzagUcLri2IfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 75/84] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak
Date:   Mon, 20 Jun 2022 14:51:38 +0200
Message-Id: <20220620124723.109661211@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -537,7 +537,7 @@ static int sev_launch_measure(struct kvm
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
@@ -676,7 +676,7 @@ static int __sev_dbg_decrypt_user(struct
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 


