Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86079191066
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgCXN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbgCXN1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADF8208D6;
        Tue, 24 Mar 2020 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056464;
        bh=7nN6GI7/68woCdwk5Vi3mTAd6ov6wAQsoBiRvtFyc1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTvDF1bAO6pMnEg27YLpatwoGUOextPsdKgl4AHxER6ziwSPWAsGDXZ2dyBZhHSMZ
         xHFu49nZj8Y6Mota5jo+Zjyb5cGWV/1SMi8osEEDgdrRQ8wDm+E3U+qoX101dAZhI8
         ZNLRQ6oe30u0nAXmP+ZRSCJbRYoimwpUSCxqm0D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom St Denis <tom.stdenis@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 089/119] drm/amd/amdgpu: Fix GPR read from debugfs (v2)
Date:   Tue, 24 Mar 2020 14:11:14 +0100
Message-Id: <20200324130817.113789314@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom St Denis <tom.stdenis@amd.com>

commit 5bbc6604a62814511c32f2e39bc9ffb2c1b92cbe upstream.

The offset into the array was specified in bytes but should
be in terms of 32-bit words.  Also prevent large reads that
would also cause a buffer overread.

v2:  Read from correct offset from internal storage buffer.

Signed-off-by: Tom St Denis <tom.stdenis@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -694,11 +694,11 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 	ssize_t result = 0;
 	uint32_t offset, se, sh, cu, wave, simd, thread, bank, *data;
 
-	if (size & 3 || *pos & 3)
+	if (size > 4096 || size & 3 || *pos & 3)
 		return -EINVAL;
 
 	/* decode offset */
-	offset = *pos & GENMASK_ULL(11, 0);
+	offset = (*pos & GENMASK_ULL(11, 0)) >> 2;
 	se = (*pos & GENMASK_ULL(19, 12)) >> 12;
 	sh = (*pos & GENMASK_ULL(27, 20)) >> 20;
 	cu = (*pos & GENMASK_ULL(35, 28)) >> 28;
@@ -729,7 +729,7 @@ static ssize_t amdgpu_debugfs_gpr_read(s
 	while (size) {
 		uint32_t value;
 
-		value = data[offset++];
+		value = data[result >> 2];
 		r = put_user(value, (uint32_t *)buf);
 		if (r) {
 			result = r;


