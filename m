Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB662A567B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgKCV2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbgKCU7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB0952053B;
        Tue,  3 Nov 2020 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437181;
        bh=L5ms5j8ReJco365fFQYVbJCEw0Wt1/KFNY135X55fwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwa02dHa+gg7ZDHdubLApG1gj3Tf1XOmoJgqD9MSFOiti19DUP3M7MMlkQo2X5H8x
         jEtW2tk2Tv2L6M567Kh8JtWCUuS03RmNft4iMqHpgfOlKPndvtmF6JD6mfYazhD9vA
         A4+szNqQx2nBIIl84GAIAJhoyU8bPZGeAUW3wn4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jane Jian <Jane.Jian@amd.com>
Subject: [PATCH 5.4 181/214] drm/amdgpu: correct the gpu reset handling for job != NULL case
Date:   Tue,  3 Nov 2020 21:37:09 +0100
Message-Id: <20201103203307.677176739@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -3890,7 +3890,7 @@ retry:	/* Rest of adevs pre asic reset f
 
 		amdgpu_device_lock_adev(tmp_adev, false);
 		r = amdgpu_device_pre_asic_reset(tmp_adev,
-						 NULL,
+						 (tmp_adev == adev) ? job : NULL,
 						 &need_full_reset);
 		/*TODO Should we stop ?*/
 		if (r) {


