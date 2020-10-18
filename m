Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB8291DE1
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgJRTVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729520AbgJRTVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A25222EB;
        Sun, 18 Oct 2020 19:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048899;
        bh=Fo0hmO1Sa6p8badjcsPN4o/MRceWT+SFDl+f6VPJMIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8OZ8sllCh82/49YqzOZyWgew1lC6JxfeK/3RUBAWWWTGlMwQ6pDog+fIH4+ZEF5i
         iZYhsTNLxrzOEeFl/cuiAzFl1fa8CDU0LShPtemIwmXHhlgd7y+Ey0m+56Fw2mogfp
         0TJfFcWOQXMYGfAce2oxz7i9Nslv0azPl9ekaqFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 060/101] drm/panfrost: add support for vendor quirk
Date:   Sun, 18 Oct 2020 15:19:45 -0400
Message-Id: <20201018192026.4053674-60-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 91e89097b86f566636ea5a7329c79d5521be46d2 ]

The T820, G31 & G52 GPUs integrated by Amlogic in the respective GXM,
G12A/SM1 & G12B SoCs needs a quirk in the PWR registers after each reset.

This adds a callback in the device compatible struct of permit this.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
[Steven: Fix typo in commit log]
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200916150147.25753-2-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.h | 3 +++
 drivers/gpu/drm/panfrost/panfrost_gpu.c    | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
index c30c719a80594..3c4a85213c15f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -69,6 +69,9 @@ struct panfrost_compatible {
 	int num_pm_domains;
 	/* Only required if num_pm_domains > 1. */
 	const char * const *pm_domain_names;
+
+	/* Vendor implementation quirks callback */
+	void (*vendor_quirk)(struct panfrost_device *pfdev);
 };
 
 struct panfrost_device {
diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 6606643850fc6..502b1f1f7b204 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -146,6 +146,10 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 
 	if (quirks)
 		gpu_write(pfdev, GPU_JM_CONFIG, quirks);
+
+	/* Here goes platform specific quirks */
+	if (pfdev->comp->vendor_quirk)
+		pfdev->comp->vendor_quirk(pfdev);
 }
 
 #define MAX_HW_REVS 6
-- 
2.25.1

