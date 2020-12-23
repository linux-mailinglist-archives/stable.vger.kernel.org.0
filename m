Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B792E16B7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgLWDBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgLWCTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924DA22202;
        Wed, 23 Dec 2020 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689959;
        bh=07FJ94/JhhjeGtGooCgnuze+tKQIH5U96CHlFU0af00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFa3GeVw3KSWYUEidErjZa2qej7snOtvL2FGGqjBAkvu+3IMgn/ezbWQ4oI9YbdKa
         XSkrt78/k8NVAP7Ecd8dOs3u2b85nRFiGU1NBkh0Gd2zgv4WbBAVRpCKNIWrqdtzxz
         RcCnogIF8/hLuUpM0gZf8bnF9xqcMj7yXjGX7JY28plQ03II4zJw/0Sh2GLljUItYK
         s44KbRvIEfR+MOjUA6SWNl+yZSBN7REu6NRCRV1uHQtiyeoJrSAd/GCzHSR6FSK3Q+
         meiaHcfOvb/zCQn6vFl1vDC74NT+BMwmfkTyG9ImI/doUrazwJMisl/ZrlS5iHBuTx
         o+5oJK6USxA5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Curtis Malainey <cujomalainey@chromium.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 051/130] ASoC: SOF: IPC: fix implicit type overflow
Date:   Tue, 22 Dec 2020 21:16:54 -0500
Message-Id: <20201223021813.2791612-51-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit 7c1d0e554a359cca77bfabd2a29b06f5322d172d ]

Implicit values may have a length of 15bits (s16) so we need to declare
the proper size so we don't get undefined behaviour. This appears to be
arch and compiler dependent. This commit is to keep the headers aligned
between the firmware and kernel. UBSan discovered this bug in the
firmware.

Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20201120144025.2166023-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sof/header.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/sof/header.h b/include/sound/sof/header.h
index 10f00c08dbb7a..aae673b2bb5e2 100644
--- a/include/sound/sof/header.h
+++ b/include/sound/sof/header.h
@@ -30,12 +30,12 @@
 
 /* Global Message - Generic */
 #define SOF_GLB_TYPE_SHIFT			28
-#define SOF_GLB_TYPE_MASK			(0xf << SOF_GLB_TYPE_SHIFT)
+#define SOF_GLB_TYPE_MASK			(0xfL << SOF_GLB_TYPE_SHIFT)
 #define SOF_GLB_TYPE(x)				((x) << SOF_GLB_TYPE_SHIFT)
 
 /* Command Message - Generic */
 #define SOF_CMD_TYPE_SHIFT			16
-#define SOF_CMD_TYPE_MASK			(0xfff << SOF_CMD_TYPE_SHIFT)
+#define SOF_CMD_TYPE_MASK			(0xfffL << SOF_CMD_TYPE_SHIFT)
 #define SOF_CMD_TYPE(x)				((x) << SOF_CMD_TYPE_SHIFT)
 
 /* Global Message Types */
-- 
2.27.0

