Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADAB1F2E62
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733243AbgFIAlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgFHXMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D172100A;
        Mon,  8 Jun 2020 23:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657968;
        bh=InbbZyHlNhJSYEISo854k5UHc9Jio+d9wJTFioivsbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMpzpoAxFhcz1PCY0BtB7coGBL0RNKVM0EsCv8cBj97UzgLQh+wH4juXOsS8arkXH
         DJgJ7lAUbDO8MO3hM+qde4SqBnRaahdhBgV7LP7dTZhXKS5Eb/XXECCI7hFgh6vzWq
         rVaEABGRfh9X4DKNopIfP6IZBLC1HNTsvCwDE878=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Jones <pjones@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 031/606] Make the "Reducing compressed framebufer size" message be DRM_INFO_ONCE()
Date:   Mon,  8 Jun 2020 19:02:36 -0400
Message-Id: <20200608231211.3363633-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

commit 82152d424b6cb6fc1ede7d03d69c04e786688740 upstream.

This was sort of annoying me:

random:~$ dmesg | tail -1
[523884.039227] [drm] Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.
random:~$ dmesg | grep -c "Reducing the compressed"
47

This patch makes it DRM_INFO_ONCE() just like the similar message
farther down in that function is pr_info_once().

Cc: stable@vger.kernel.org
Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1745
Link: https://patchwork.freedesktop.org/patch/msgid/20180706190424.29194-1-pjones@redhat.com
[vsyrjala: Rebase due to per-device logging]
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit 6b7fc6a3e6af4ff5773949d0fed70d8e7f68d5ce)
[Rodrigo: port back to DRM_INFO_ONCE]
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index a1048ece541e..b6d5e7defa5b 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -478,8 +478,7 @@ static int intel_fbc_alloc_cfb(struct drm_i915_private *dev_priv,
 	if (!ret)
 		goto err_llb;
 	else if (ret > 1) {
-		DRM_INFO("Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.\n");
-
+		DRM_INFO_ONCE("Reducing the compressed framebuffer size. This may lead to less power savings than a non-reduced-size. Try to increase stolen memory size if available in BIOS.\n");
 	}
 
 	fbc->threshold = ret;
-- 
2.25.1

