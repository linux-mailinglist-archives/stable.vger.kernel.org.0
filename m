Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935ED353D78
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbhDEJAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237101AbhDEI75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5652F6124C;
        Mon,  5 Apr 2021 08:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613191;
        bh=D+3gd6YR+wUOu0FLBNxzwPKWqhrQkSkF8rqmIOhMurk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4e67I6XrsL6c5LK7pxkIdggAlBQMLYCw65RNh+DELX9u4Ki+E+zX0nqR5bOgZbfr
         jVmMZheuQe+IabYuFivoM3KAwvWNdS2CG7SteEBh8yxW+dFDFniy7ZgO3eYnOrMC0Y
         IKucPN/ViG3Uqyix5HeWhGU/STviBWGlKmZ6Zzt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.14 29/52] drm/amdgpu: fix offset calculation in amdgpu_vm_bo_clear_mappings()
Date:   Mon,  5 Apr 2021 10:53:55 +0200
Message-Id: <20210405085022.937617437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -2285,7 +2285,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += after->start - tmp->start;
+			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
 			after->flags = tmp->flags;
 			list_add(&after->list, &tmp->list);
 		}


