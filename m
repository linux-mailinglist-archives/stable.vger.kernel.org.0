Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5258230CC68
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbhBBTzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233097AbhBBNva (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C59364FB4;
        Tue,  2 Feb 2021 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273389;
        bh=/oxlEIfmU57N6kcLOcmTfCQxXgj9arOTSSj3O7Lvp5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXLm166vEdm2kvD2G2NKstDzjCOqpxF5kXP3q21YBwENQ/qzee1mikyknm0FxtYig
         i/QojHdJbsPqqrpP6b1Q06EYB3CQyce0d7gXZa/4Zyy9HkGlgRvk0RD8bKX2DG+kgn
         ECzqHq2evz/evzMwqoboHlrQVEkh6BanWLTsCuLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Nie <jun.nie@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Srinivasa Rao <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/142] ASoC: dt-bindings: lpass: Fix and common up lpass dai ids
Date:   Tue,  2 Feb 2021 14:37:32 +0100
Message-Id: <20210202133001.375135742@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 09a4f6f5d21cb1f2633f4e8b893336b60eee9a01 ]

Existing header file design of having separate SoC specific header files
for the common lpass driver has mutiple issues.
This design is prone to break as an when new SoC header is added
as the common DAI ids of other SoCs will be overwritten by the
new ones.

One of them surfaced by recent patch that adds support to sc7180, this
one totally broke LPASS drivers on other Qualcomm SoCs.

Before this gets worst, fix this by having a common header qcom,lpass.h.
This should fix the issue and any new DAI ids should be added to the
common header. This will be more sustainable then the existing design!

Fixes: 12fbfc4cabec6595 ("ASoC: Add sc7180-lpass binding header hdmi define")
Reported-by: Jun Nie <jun.nie@linaro.org>
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Srinivasa Rao <srivasam@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210119171527.32145-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/sound/apq8016-lpass.h |  7 +++----
 include/dt-bindings/sound/qcom,lpass.h    | 15 +++++++++++++++
 include/dt-bindings/sound/sc7180-lpass.h  |  6 ++----
 3 files changed, 20 insertions(+), 8 deletions(-)
 create mode 100644 include/dt-bindings/sound/qcom,lpass.h

diff --git a/include/dt-bindings/sound/apq8016-lpass.h b/include/dt-bindings/sound/apq8016-lpass.h
index 3c3e16c0aadbf..dc605c4bc2249 100644
--- a/include/dt-bindings/sound/apq8016-lpass.h
+++ b/include/dt-bindings/sound/apq8016-lpass.h
@@ -2,9 +2,8 @@
 #ifndef __DT_APQ8016_LPASS_H
 #define __DT_APQ8016_LPASS_H
 
-#define MI2S_PRIMARY	0
-#define MI2S_SECONDARY	1
-#define MI2S_TERTIARY	2
-#define MI2S_QUATERNARY	3
+#include <dt-bindings/sound/qcom,lpass.h>
+
+/* NOTE: Use qcom,lpass.h to define any AIF ID's for LPASS */
 
 #endif /* __DT_APQ8016_LPASS_H */
diff --git a/include/dt-bindings/sound/qcom,lpass.h b/include/dt-bindings/sound/qcom,lpass.h
new file mode 100644
index 0000000000000..7b0b80b38699e
--- /dev/null
+++ b/include/dt-bindings/sound/qcom,lpass.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __DT_QCOM_LPASS_H
+#define __DT_QCOM_LPASS_H
+
+#define MI2S_PRIMARY	0
+#define MI2S_SECONDARY	1
+#define MI2S_TERTIARY	2
+#define MI2S_QUATERNARY	3
+#define MI2S_QUINARY	4
+
+#define LPASS_DP_RX	5
+
+#define LPASS_MCLK0	0
+
+#endif /* __DT_QCOM_LPASS_H */
diff --git a/include/dt-bindings/sound/sc7180-lpass.h b/include/dt-bindings/sound/sc7180-lpass.h
index 56ecaafd2dc68..5c1ee8b36b197 100644
--- a/include/dt-bindings/sound/sc7180-lpass.h
+++ b/include/dt-bindings/sound/sc7180-lpass.h
@@ -2,10 +2,8 @@
 #ifndef __DT_SC7180_LPASS_H
 #define __DT_SC7180_LPASS_H
 
-#define MI2S_PRIMARY	0
-#define MI2S_SECONDARY	1
-#define LPASS_DP_RX	2
+#include <dt-bindings/sound/qcom,lpass.h>
 
-#define LPASS_MCLK0	0
+/* NOTE: Use qcom,lpass.h to define any AIF ID's for LPASS */
 
 #endif /* __DT_APQ8016_LPASS_H */
-- 
2.27.0



