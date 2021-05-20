Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B42038A66A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbhETK0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236882AbhETKYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AD061C22;
        Thu, 20 May 2021 09:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504180;
        bh=yHeNw5XrD0xJO+tRISAzog9L/HQZ5m3hnns6KRmPw9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwlOq91A+2CPwz9nKw8eS+Ue7vDMIQ9bs9YWZkF2rpM3HOiDqsWm8OfPJoFKv34Zt
         /vLpjcbxDk84lyZuhlwUdAYkJ7nPs4x8swYaNuvetf4/uNzrLpOrHt8ZYPd2b9Cg2O
         NM4S3lNM5vzbmZqnL8yXxFTYX5ve2wKP1kVt9G18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.14 127/323] drm/radeon: fix copy of uninitialized variable back to userspace
Date:   Thu, 20 May 2021 11:20:19 +0200
Message-Id: <20210520092124.463608385@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 8dbc2ccac5a65c5b57e3070e36a3dc97c7970d96 upstream.

Currently the ioctl command RADEON_INFO_SI_BACKEND_ENABLED_MASK can
copy back uninitialised data in value_tmp that pointer *value points
to. This can occur when rdev->family is less than CHIP_BONAIRE and
less than CHIP_TAHITI.  Fix this by adding in a missing -EINVAL
so that no invalid value is copied back to userspace.

Addresses-Coverity: ("Uninitialized scalar variable)
Cc: stable@vger.kernel.org # 3.13+
Fixes: 439a1cfffe2c ("drm/radeon: expose render backend mask to the userspace")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -531,6 +531,7 @@ static int radeon_info_ioctl(struct drm_
 			*value = rdev->config.si.backend_enable_mask;
 		} else {
 			DRM_DEBUG_KMS("BACKEND_ENABLED_MASK is si+ only!\n");
+			return -EINVAL;
 		}
 		break;
 	case RADEON_INFO_MAX_SCLK:


