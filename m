Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B537CB88
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242785AbhELQfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241609AbhELQ1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E48AA61DF0;
        Wed, 12 May 2021 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834855;
        bh=0oWb2oRdauCVrtCSN6Hyx8bXifYEBtbtuqRG+ANkCnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDc0qJ3w4x/hECwMhDQB+Sqp1x8LwoFWqOi0/d4UZ/VVSardFFeYrKtBTV2xB4Mxq
         doi9sfs6DXFBOBYFnirCmAgl+FjrQp1PgJgr/7ek5e1nhIx2OGeUaEO+pQ0XOsbOVo
         knUci2X999Fsq+n1jMLQgyz6KA9xHD05A0ML7pPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 075/677] drm/radeon: fix copy of uninitialized variable back to userspace
Date:   Wed, 12 May 2021 16:42:01 +0200
Message-Id: <20210512144839.726584674@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -518,6 +518,7 @@ int radeon_info_ioctl(struct drm_device
 			*value = rdev->config.si.backend_enable_mask;
 		} else {
 			DRM_DEBUG_KMS("BACKEND_ENABLED_MASK is si+ only!\n");
+			return -EINVAL;
 		}
 		break;
 	case RADEON_INFO_MAX_SCLK:


