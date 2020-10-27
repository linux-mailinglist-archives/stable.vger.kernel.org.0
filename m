Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC36929BBBB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809620AbgJ0Q07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802769AbgJ0PvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:51:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FEC207C3;
        Tue, 27 Oct 2020 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813877;
        bh=MIJdmlDPf/6a9ww6acyCu/XbTZ0zqwY1PWgU7Qwbn/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxcCOwb9xnevQ5S3I9CRVhs41ZTLeCWxS3V9DqMKS1VuxKLrub69XGwBh5NOkgL9y
         W3v4KWZ8ORdKqar/rs4Dx1chadIE2FpCO7tEz+v9uxavetmD6VeLuJK3pLm4li6Wn0
         ByLevZq1ToQO0W3qQPp2y33BPvzu5xf+Ah7clHu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 700/757] drm/panfrost: add support for vendor quirk
Date:   Tue, 27 Oct 2020 14:55:50 +0100
Message-Id: <20201027135523.337662798@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a9d08a2927aa3..165403878ad9b 100644
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



