Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D8B2A5270
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgKCUuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbgKCUuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D91223FD;
        Tue,  3 Nov 2020 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436601;
        bh=Sucy8dbXgJwgZTIjyulq7Mxs+SihhI22QUtLc6wogHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg9bZdC9a243h/ZrlG7olwCaOwbzkUVxnXXbK33GZn5P0p55pbwBI/lkQshVgSaya
         IB4ePdpxql4cjfCDJtpjUfYsMovqw8n/yMWIARsUXbyLu97EKEDr18Igm/mV7gTffn
         uwY23z0kw0SBroe5etZJ2G64MjS/3Ih0CKny3bcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jane Jian <Jane.Jian@amd.com>
Subject: [PATCH 5.9 321/391] drm/amdgpu: correct the gpu reset handling for job != NULL case
Date:   Tue,  3 Nov 2020 21:36:12 +0100
Message-Id: <20201103203408.771114455@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 207ac684792560acdb9e06f9d707ebf63c84b0e0 upstream.

Current code wrongly treat all cases as job == NULL.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-and-tested-by: Jane Jian <Jane.Jian@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4374,7 +4374,7 @@ int amdgpu_device_gpu_recover(struct amd
 retry:	/* Rest of adevs pre asic reset from XGMI hive. */
 	list_for_each_entry(tmp_adev, device_list_handle, gmc.xgmi.head) {
 		r = amdgpu_device_pre_asic_reset(tmp_adev,
-						 NULL,
+						 (tmp_adev == adev) ? job : NULL,
 						 &need_full_reset);
 		/*TODO Should we stop ?*/
 		if (r) {


