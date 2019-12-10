Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF895119322
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfLJVG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfLJVEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6801221D7D;
        Tue, 10 Dec 2019 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011852;
        bh=ceteDlM2gzudgpK7lNIbnJYzwn+zR/DJXRfsggSRc00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWZLDrdgdmxqvSiASswsIDBFiLH6jJIT7+masRpXwKfUip0Bpe44enKWZwftOMnH6
         Xgi/nAiSZa4oG5/NNZYE8QftEGp0OugucXwWPc7v4niwQ6E+JveTvD5zfKRU5nehJK
         lDxex0ew0pRBUmI64CMLZdUB8tZmzH6kzNu8CuJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sean Paul <sean@poorly.run>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andres Rodriguez <andresx7@gmail.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 007/350] drm: Use EOPNOTSUPP, not ENOTSUPP
Date:   Tue, 10 Dec 2019 15:58:19 -0500
Message-Id: <20191210210402.8367-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit c7581a414d28413c1dd6d116d44859b5a52e0950 ]

- it's what we recommend in our docs:

https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#recommended-ioctl-return-values

- it's the overwhelmingly used error code for "operation not
  supported", at least in drm core (slightly less so in drivers):

$ git grep EOPNOTSUPP -- drivers/gpu/drm/*c | wc -l
83
$ git grep ENOTSUPP -- drivers/gpu/drm/*c | wc -l
5

- include/linux/errno.h makes it fairly clear that these are for nfsv3
  (plus they also have error codes above 512, which is the block with
  some special behaviour ...)

/* Defined for the NFSv3 protocol */

If the above isn't reflecting current practice, then I guess we should
at least update the docs.

Noralf commented:

Ben Hutchings made this comment[1] in a thread about use of ENOTSUPP in
drivers:

  glibc's strerror() returns these strings for ENOTSUPP and EOPNOTSUPP
  respectively:

  "Unknown error 524"
  "Operation not supported"

So at least for errors returned to userspace EOPNOTSUPP makes sense.

José asked:

> Hopefully this will not break any userspace

None of the functions in drm_edid.c affected by this reach userspace,
it's all driver internal.

Same for the mipi function, that error code should be handled by
drivers. Drivers are supposed to remap "the hw is on fire" to EIO when
reporting up to userspace, but I think if a driver sees this it would
be a driver bug.
v2: Augment commit message with comments from Noralf and José

Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Acked-by: Noralf Trønnes <noralf@tronnes.org>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Sean Paul <sean@poorly.run>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Andres Rodriguez <andresx7@gmail.com>
Cc: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190904143942.31756-1-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c     | 6 +++---
 drivers/gpu/drm/drm_mipi_dbi.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 6b0177112e18d..3f50b8865db4c 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3722,7 +3722,7 @@ cea_db_offsets(const u8 *cea, int *start, int *end)
 		if (*end < 4 || *end > 127)
 			return -ERANGE;
 	} else {
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -4191,7 +4191,7 @@ int drm_edid_to_sad(struct edid *edid, struct cea_sad **sads)
 
 	if (cea_revision(cea) < 3) {
 		DRM_DEBUG_KMS("SAD: wrong CEA revision\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	if (cea_db_offsets(cea, &start, &end)) {
@@ -4252,7 +4252,7 @@ int drm_edid_to_speaker_allocation(struct edid *edid, u8 **sadb)
 
 	if (cea_revision(cea) < 3) {
 		DRM_DEBUG_KMS("SAD: wrong CEA revision\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	if (cea_db_offsets(cea, &start, &end)) {
diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
index c4ee2709a6f32..f8154316a3b0d 100644
--- a/drivers/gpu/drm/drm_mipi_dbi.c
+++ b/drivers/gpu/drm/drm_mipi_dbi.c
@@ -955,7 +955,7 @@ static int mipi_dbi_typec1_command(struct mipi_dbi *dbi, u8 *cmd,
 	int ret;
 
 	if (mipi_dbi_command_is_read(dbi, *cmd))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	MIPI_DBI_DEBUG_COMMAND(*cmd, parameters, num);
 
-- 
2.20.1

