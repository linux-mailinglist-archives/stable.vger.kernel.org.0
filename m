Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3420DA24
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbgF2TyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387685AbgF2Tk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3E624A61;
        Mon, 29 Jun 2020 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444488;
        bh=g+DGo3QNojV3iZV97JWZy5+xro4CU11v1elMrg288qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThVSdCPrfAbQ19eE08OVHA/LdJjf5x758J8SazOHdWBJqGfC/6c0R9Dxf6pOCAJkF
         Q6KOWK4gG2F9XgmdkX8wJ08cKWiDS5yfB47jDYtnAPX0jf2xixz4afSNtbU68S+YZQ
         9hNsdBFSqpRCf/YXhpX+84TrpalaYxUZwghkrW/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 165/178] drm/amd: fix potential memleak in err branch
Date:   Mon, 29 Jun 2020 11:25:10 -0400
Message-Id: <20200629152523.2494198-166-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

commit b5b78a6c8d8cb9c307bc6b16a754603424459d6e upstream.

The function kobject_init_and_add alloc memory like:
kobject_init_and_add->kobject_add_varg->kobject_set_name_vargs
->kvasprintf_const->kstrdup_const->kstrdup->kmalloc_track_caller
->kmalloc_slab, in err branch this memory not free. If use
kmemleak, this path maybe catched.
These changes are to add kobject_put in kobject_init_and_add
failed branch, fix potential memleak.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 40e3fc0c69421..aa0a617b8d445 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -312,6 +312,7 @@ struct kfd_process *kfd_create_process(struct file *filep)
 					   (int)process->lead_thread->pid);
 		if (ret) {
 			pr_warn("Creating procfs pid directory failed");
+			kobject_put(process->kobj);
 			goto out;
 		}
 
-- 
2.25.1

