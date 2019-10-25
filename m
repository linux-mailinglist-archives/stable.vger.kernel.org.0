Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC8E4E22
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505268AbfJYN41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505261AbfJYN40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEF221D7F;
        Fri, 25 Oct 2019 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011785;
        bh=N76CoPzdJ7FfQP3LJQW2Rr6UIbvii3tkzOHeMY72w/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jOBBl0JOuNBqPn4fUmlZXGtcUhQuczROkcGu0/+oJbDzDNI5DT6Ml/5XB50V9UDb
         r7Wol/VlsNiXjRDmpLApQgvofKn48iKfP1JiOvJue3ozRx06Bg0CI9yiYmkn+T7a8b
         leR1CVfCCdn1sz7JHGbxgfHmd50b5I0oHiPqcaqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emily Deng <Emily.Deng@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 12/37] drm/amdgpu/display: Fix reload driver error
Date:   Fri, 25 Oct 2019 09:55:36 -0400
Message-Id: <20191025135603.25093-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit 526c654a8a0641d4289bf65effde4d6095bd8384 ]

Issue:
Will have follow error when reload driver:
[ 3986.567739] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:07.0/drm_dp_aux_dev'
[ 3986.567743] CPU: 6 PID: 1767 Comm: modprobe Tainted: G           OE     5.0.0-rc1-custom #1
[ 3986.567745] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 3986.567746] Call Trace:
......
[ 3986.567808]  drm_dp_aux_register_devnode+0xdc/0x140 [drm_kms_helper]
......
[ 3986.569081] kobject_add_internal failed for drm_dp_aux_dev with -EEXIST, don't try to register things with the same name in the same directory.

Reproduce sequences:
1.modprobe amdgpu
2.modprobe -r amdgpu
3.modprobe amdgpu

Root cause:
When unload driver, it doesn't unregister aux.

v2: Don't use has_aux

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3b07a316680c2..5209b76262311 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2870,6 +2870,13 @@ int amdgpu_dm_connector_atomic_get_property(struct drm_connector *connector,
 	return ret;
 }
 
+static void amdgpu_dm_connector_unregister(struct drm_connector *connector)
+{
+	struct amdgpu_dm_connector *amdgpu_dm_connector = to_amdgpu_dm_connector(connector);
+
+	drm_dp_aux_unregister(&amdgpu_dm_connector->dm_dp_aux.aux);
+}
+
 static void amdgpu_dm_connector_destroy(struct drm_connector *connector)
 {
 	struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
@@ -2889,6 +2896,11 @@ static void amdgpu_dm_connector_destroy(struct drm_connector *connector)
 #endif
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
+	if (aconnector->i2c) {
+		i2c_del_adapter(&aconnector->i2c->base);
+		kfree(aconnector->i2c);
+	}
+
 	kfree(connector);
 }
 
@@ -2942,7 +2954,8 @@ static const struct drm_connector_funcs amdgpu_dm_connector_funcs = {
 	.atomic_duplicate_state = amdgpu_dm_connector_atomic_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 	.atomic_set_property = amdgpu_dm_connector_atomic_set_property,
-	.atomic_get_property = amdgpu_dm_connector_atomic_get_property
+	.atomic_get_property = amdgpu_dm_connector_atomic_get_property,
+	.early_unregister = amdgpu_dm_connector_unregister
 };
 
 static struct drm_encoder *best_encoder(struct drm_connector *connector)
-- 
2.20.1

