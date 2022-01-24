Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B5A499DC7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586226AbiAXWZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583215AbiAXWRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10D7C04A2E8;
        Mon, 24 Jan 2022 12:46:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E1ABB81255;
        Mon, 24 Jan 2022 20:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96356C340E5;
        Mon, 24 Jan 2022 20:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057179;
        bh=MpuM4LnY9B+O0T3OuYSyok+AoWxmtiacIkWoare4NoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTDEsrMsVQddJaerv+ARr67YvIPzi/iWAkprykHAvm0zXjuypAq1gH1r+FjjfselF
         Xw29BIPKFz1ejlG5CqpTMg2KGC6vWxAy9eM5lS7chB1ScdCfJLIKabg/BAZX5Odz3t
         3+oyuDPZ53D0a/ZKAksACumhdu5UBvaCOOSNJkdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 728/846] Revert "drm/amdgpu: Dont inherit GEM object VMAs in child process"
Date:   Mon, 24 Jan 2022 19:44:05 +0100
Message-Id: <20220124184126.120937403@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>

commit 8b5da5a458c95ad49571a6a6285800bf13409616 upstream.

This reverts commit fbcdbfde87509d523132b59f661a355c731139d0.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -264,9 +264,6 @@ static int amdgpu_gem_object_mmap(struct
 	    !(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
 		vma->vm_flags &= ~VM_MAYWRITE;
 
-	if (bo->kfd_bo)
-		vma->vm_flags |= VM_DONTCOPY;
-
 	return drm_gem_ttm_mmap(obj, vma);
 }
 


