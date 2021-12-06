Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1446A9A7
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350848AbhLFVTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350638AbhLFVSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:18:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E749C0698C1;
        Mon,  6 Dec 2021 13:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABCEECE1861;
        Mon,  6 Dec 2021 21:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367DEC341CA;
        Mon,  6 Dec 2021 21:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825307;
        bh=p4q2jJiqmTvTg/BQqSl9uEEFfH48wa23OnPgltutTCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sjq6bhJkYgaJiGUUlD6f/4ZAXvRmuXOyySS+h8UVep0p00DWfp1KXd9pLFnbVoP3D
         V4+pjSOsNIVK6Jw0lC3jVtUJLT6BsWb1fyqDcB13oeWHLd0A0mfA9/rdYZUBhzlPbC
         JjRgEhYKJ9YgpT0m0zhVH5gajOneDejVCAB17vdEOLfxzZmqbvG4162v9zt2AFcOG7
         xfIdCZ22GkVMaGR0rUz/hE7BJPYsxVuZ0RWirUHePKKjqtyK3YsiUjMAb1EFQXlUB2
         b4m+QxEhlmW7maNQXBoNp8Iyjnwo3M8fZEE4Yu4oIN/+HYQ6W7P80lgvvdGc9ktEAP
         PCA9EFeovmOmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 22/24] drm/amdkfd: process_info lock not needed for svm
Date:   Mon,  6 Dec 2021 16:12:27 -0500
Message-Id: <20211206211230.1660072-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 3abfe30d803e62cc75dec254eefab3b04d69219b ]

process_info->lock is used to protect kfd_bo_list, vm_list_head, n_vms
and userptr valid/inval list, svm_range_restore_work and
svm_range_set_attr don't access those, so do not need to take
process_info lock. This will avoid potential circular locking issue.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 179080329af89..5a674235ae41a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1565,7 +1565,6 @@ svm_range_list_lock_and_flush_work(struct svm_range_list *svms,
 static void svm_range_restore_work(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct amdkfd_process_info *process_info;
 	struct svm_range_list *svms;
 	struct svm_range *prange;
 	struct kfd_process *p;
@@ -1585,12 +1584,10 @@ static void svm_range_restore_work(struct work_struct *work)
 	 * the lifetime of this thread, kfd_process and mm will be valid.
 	 */
 	p = container_of(svms, struct kfd_process, svms);
-	process_info = p->kgd_process_info;
 	mm = p->mm;
 	if (!mm)
 		return;
 
-	mutex_lock(&process_info->lock);
 	svm_range_list_lock_and_flush_work(svms, mm);
 	mutex_lock(&svms->lock);
 
@@ -1643,7 +1640,6 @@ static void svm_range_restore_work(struct work_struct *work)
 out_reschedule:
 	mutex_unlock(&svms->lock);
 	mmap_write_unlock(mm);
-	mutex_unlock(&process_info->lock);
 
 	/* If validation failed, reschedule another attempt */
 	if (evicted_ranges) {
@@ -2974,7 +2970,6 @@ static int
 svm_range_set_attr(struct kfd_process *p, uint64_t start, uint64_t size,
 		   uint32_t nattr, struct kfd_ioctl_svm_attribute *attrs)
 {
-	struct amdkfd_process_info *process_info = p->kgd_process_info;
 	struct mm_struct *mm = current->mm;
 	struct list_head update_list;
 	struct list_head insert_list;
@@ -2993,8 +2988,6 @@ svm_range_set_attr(struct kfd_process *p, uint64_t start, uint64_t size,
 
 	svms = &p->svms;
 
-	mutex_lock(&process_info->lock);
-
 	svm_range_list_lock_and_flush_work(svms, mm);
 
 	if (!svm_range_is_valid(mm, start, size)) {
@@ -3070,8 +3063,6 @@ svm_range_set_attr(struct kfd_process *p, uint64_t start, uint64_t size,
 	mutex_unlock(&svms->lock);
 	mmap_read_unlock(mm);
 out:
-	mutex_unlock(&process_info->lock);
-
 	pr_debug("pasid 0x%x svms 0x%p [0x%llx 0x%llx] done, r=%d\n", p->pasid,
 		 &p->svms, start, start + size - 1, r);
 
-- 
2.33.0

