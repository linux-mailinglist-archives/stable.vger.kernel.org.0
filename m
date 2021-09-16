Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A583340E8A6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356094AbhIPRpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355646AbhIPRlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B419261AA6;
        Thu, 16 Sep 2021 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811217;
        bh=QG1gPTa/DmDNNQMF8PqFnP80ZYjKSkN245cHYp+mJhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIahKCR/SXk0BGOM9Lbf8kAlG9lsOtvoSYdndOkef57JQgayEx9a3+oZI80AYH19k
         jgY7JVQYNbEBvJ/gmLieypE3FBxjX+4GwMmXUyt1vg4CWqkNf+JFV36+JtH5Q9x9ZE
         pYJbR4j0ujPHrF49laVFSvtnV77mhWMVbf6eO0lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Sierra <alex.sierra@amd.com>,
        Philip Yang <philip.yang@amd.com>,
        Jonathan Kim <jonathan.kim@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 425/432] drm/amdkfd: drop process ref count when xnack disable
Date:   Thu, 16 Sep 2021 18:02:54 +0200
Message-Id: <20210916155825.246047518@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sierra <alex.sierra@amd.com>

commit d6043581e1d9d0507a8413a302db0e35c8506e0e upstream.

During svm restore pages interrupt handler, kfd_process ref count was
never dropped when xnack was disabled. Therefore, the object was never
released.

Fixes: 2383f56bbe4a ("drm/amdkfd: page table restore through svm API")
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -2426,7 +2426,8 @@ svm_range_restore_pages(struct amdgpu_de
 	}
 	if (!p->xnack_enabled) {
 		pr_debug("XNACK not enabled for pasid 0x%x\n", pasid);
-		return -EFAULT;
+		r = -EFAULT;
+		goto out;
 	}
 	svms = &p->svms;
 


