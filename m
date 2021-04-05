Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D2A353DB6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhDEJCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237287AbhDEJB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFD89613A0;
        Mon,  5 Apr 2021 09:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613281;
        bh=g0qZpeSPtzZVibiraWCZWalUtxFApgC2P7j26wf8bcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmfz2GppDmDlt2EzdLUZ6t+UBCZik0VX+88ilkcrxUxyt4CrEGGnLpq6wz+2V0fvr
         kqpdPbdMxQIDf0es/J30Pa7zas0N0aZkyEjTBxCOoiGFTBn8g/re9FEqumTfWSpACC
         dFMNf4M13ElFfNo0DOqVlo8WS87UHd+4Yz1YVAT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 36/56] drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()
Date:   Mon,  5 Apr 2021 10:54:07 +0200
Message-Id: <20210405085023.687164208@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit 5e61b84f9d3ddfba73091f9fbc940caae1c9eb22 upstream.

Offset calculation wasn't correct as start addresses are in pfn
not in bytes.

CC: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2286,7 +2286,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += after->start - tmp->start;
+			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


