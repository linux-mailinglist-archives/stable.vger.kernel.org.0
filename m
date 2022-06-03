Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6905B53D064
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346162AbiFCSDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346456AbiFCSBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A8B56C25;
        Fri,  3 Jun 2022 10:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1BD60F3B;
        Fri,  3 Jun 2022 17:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862C4C341C6;
        Fri,  3 Jun 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279022;
        bh=4VdjQBOf3jnTTd1WKTY/qJzK8WAWb5QYzkD9VU0fllk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdyvD2mzeX4Nr2uRjDLLqDVC7HWE5o/wfT6DoCoiY/algPHyF3wVL4TkvZ5TLwiME
         h5Dp7Zu7OggOiBK4NKK7T/8cUePYcuUWzBqKoIzAtd2SKlnc1btjKmHi/CFWsIZPsp
         GgrHKvA5XVg9Hskx5nIjVH/tUzUUhHUrUDmN0H8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 27/67] KVM: x86/mmu: Dont rebuild page when the page is synced and no tlb flushing is required
Date:   Fri,  3 Jun 2022 19:43:28 +0200
Message-Id: <20220603173821.507311892@linuxfoundation.org>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

commit 8d5678a76689acbf91245a3791fe853ab773090f upstream.

Before Commit c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page()
to return true when remote flush is needed"), the return value
of kvm_sync_page() indicates whether the page is synced, and
kvm_mmu_get_page() would rebuild page when the sync fails.
But now, kvm_sync_page() returns false when the page is
synced and no tlb flushing is required, which leads to
rebuild page in kvm_mmu_get_page(). So return the return
value of mmu->sync_page() directly and check it in
kvm_mmu_get_page(). If the sync fails, the page will be
zapped and the invalid_list is not empty, so set flush as
true is accepted in mmu_sync_children().

Cc: stable@vger.kernel.org
Fixes: c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page() to return true when remote flush is needed")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Acked-by: Lai Jiangshan <jiangshanlai@gmail.com>
Message-Id: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
[mmu_sync_children should not flush if the page is zapped. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1843,17 +1843,14 @@ static void kvm_mmu_commit_zap_page(stru
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
 	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
 
-	if (ret < 0) {
+	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
-		return false;
-	}
-
-	return !!ret;
+	return ret;
 }
 
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
@@ -1975,7 +1972,7 @@ static int mmu_sync_children(struct kvm_
 
 		for_each_sp(pages, sp, parents, i) {
 			kvm_unlink_unsync_page(vcpu->kvm, sp);
-			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
+			flush |= kvm_sync_page(vcpu, sp, &invalid_list) > 0;
 			mmu_pages_clear_parents(&parents);
 		}
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
@@ -2016,6 +2013,7 @@ static struct kvm_mmu_page *kvm_mmu_get_
 	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
+	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
@@ -2068,11 +2066,13 @@ static struct kvm_mmu_page *kvm_mmu_get_
 			 * If the sync fails, the page is zapped.  If so, break
 			 * in order to rebuild it.
 			 */
-			if (!kvm_sync_page(vcpu, sp, &invalid_list))
+			ret = kvm_sync_page(vcpu, sp, &invalid_list);
+			if (ret < 0)
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (ret > 0)
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);


