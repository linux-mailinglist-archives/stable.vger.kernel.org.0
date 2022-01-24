Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E97499B21
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574617AbiAXVt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56880 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456943AbiAXVkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D79B61469;
        Mon, 24 Jan 2022 21:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A861C340E4;
        Mon, 24 Jan 2022 21:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060430;
        bh=MpuM4LnY9B+O0T3OuYSyok+AoWxmtiacIkWoare4NoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u8Uw0WM+bjxIerS49FlRfsRVS0GAzrZpHoz3rCtHPvw7emkxFHo1nppH3xUjpTJ+
         2cyuDV5aTddYM8Jnd7YPuMPlJaYW5fCTJfF64ukpTNPkQnk93vYgT1cciklRKrQrcz
         fu1vHYo664Bj3G/mEvpzzAEn5bzf7rE0ilPJJjJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 0902/1039] Revert "drm/amdgpu: Dont inherit GEM object VMAs in child process"
Date:   Mon, 24 Jan 2022 19:44:51 +0100
Message-Id: <20220124184155.609507835@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 


