Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B1A3289B4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhCASDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237760AbhCAR4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E9ED64E68;
        Mon,  1 Mar 2021 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619610;
        bh=7bOVi5QeO0ZI6GCCpMApZD7XaFmNaW3HVYd2JXMWA/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPe+d+I7DbO8t3IM8EP3lRmh93lDHmDIruEQGcXZRDJJRxJs9CL1AeJ/3g7NH+lIv
         qHe22yiV4kbbaDCBdtBfDtyMYemWjCMLdnu+NzLTrdbt0lBIwFiHwPYhMCeyc2JqYS
         5/zlZMXxVFkQTPPdofMxluht4f1FneTkCThNfD7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 516/663] drm/amdkfd: Fix recursive lock warnings
Date:   Mon,  1 Mar 2021 17:12:44 +0100
Message-Id: <20210301161207.384598122@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit 1fb8b1fc4dd1035a264c81d15d41f05884cc8058 upstream.

memalloc_nofs_save/restore are no longer sufficient to prevent recursive
lock warnings when holding locks that can be taken in MMU notifiers. Use
memalloc_noreclaim_save/restore instead.

Fixes: f920e413ff9c ("mm: track mmu notifiers in fs_reclaim_acquire/release")
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@ -243,11 +243,11 @@ get_sh_mem_bases_nybble_64(struct kfd_pr
 static inline void dqm_lock(struct device_queue_manager *dqm)
 {
 	mutex_lock(&dqm->lock_hidden);
-	dqm->saved_flags = memalloc_nofs_save();
+	dqm->saved_flags = memalloc_noreclaim_save();
 }
 static inline void dqm_unlock(struct device_queue_manager *dqm)
 {
-	memalloc_nofs_restore(dqm->saved_flags);
+	memalloc_noreclaim_restore(dqm->saved_flags);
 	mutex_unlock(&dqm->lock_hidden);
 }
 


