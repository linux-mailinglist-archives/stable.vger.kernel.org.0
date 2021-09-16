Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1340E69B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347439AbhIPRWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352226AbhIPRUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D5B61B9F;
        Thu, 16 Sep 2021 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810545;
        bh=qgrvvbgVxAgBnFAp5WVpU5JvVXZIGj1Kxl6i3UuX4rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV1tACSBzIm2OGFCZv4H8TONJZhQ2a5C2MmVyooszBjJsUCwoSWCoZ00zYD/4m1tQ
         yIZVxuIeUxo6+Dsfp+pnalUpkV/4v7XkzMD1yUUa34F0IKAACw4HtaVbQUvTvBNn2i
         Ic4a+E2CFY0oZuvASbJvx6tpJvUPsfmR4wD6xe0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        John Clements <john.clements@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 163/432] drm/amdgpu: Fix koops when accessing RAS EEPROM
Date:   Thu, 16 Sep 2021 17:58:32 +0200
Message-Id: <20210916155816.273246131@linuxfoundation.org>
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

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 1d9d2ca85b32605ac9c74c8fa42d0c1cfbe019d4 ]

Debugfs RAS EEPROM files are available when
the ASIC supports RAS, and when the debugfs is
enabled, an also when "ras_enable" module
parameter is set to 0. However in this case,
we get a kernel oops when accessing some of
the "ras_..." controls in debugfs. The reason
for this is that struct amdgpu_ras::adev is
unset. This commit sets it, thus enabling access
to those facilities. Note that this facilitates
EEPROM access and not necessarily RAS features or
functionality.

Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Cc: John Clements <john.clements@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index fc66aca28594..95d5842385b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1966,11 +1966,20 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	bool exc_err_limit = false;
 	int ret;
 
-	if (adev->ras_enabled && con)
-		data = &con->eh_data;
-	else
+	if (!con)
+		return 0;
+
+	/* Allow access to RAS EEPROM via debugfs, when the ASIC
+	 * supports RAS and debugfs is enabled, but when
+	 * adev->ras_enabled is unset, i.e. when "ras_enable"
+	 * module parameter is set to 0.
+	 */
+	con->adev = adev;
+
+	if (!adev->ras_enabled)
 		return 0;
 
+	data = &con->eh_data;
 	*data = kmalloc(sizeof(**data), GFP_KERNEL | __GFP_ZERO);
 	if (!*data) {
 		ret = -ENOMEM;
@@ -1980,7 +1989,6 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	mutex_init(&con->recovery_lock);
 	INIT_WORK(&con->recovery_work, amdgpu_ras_do_recovery);
 	atomic_set(&con->in_recovery, 0);
-	con->adev = adev;
 
 	max_eeprom_records_len = amdgpu_ras_eeprom_get_record_max_length();
 	amdgpu_ras_validate_threshold(adev, max_eeprom_records_len);
-- 
2.30.2



