Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4301AFA5A7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfKMCYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:24:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbfKMBwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D4E222CE;
        Wed, 13 Nov 2019 01:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609933;
        bh=/fUyGVnz4vUZV7QqWfrT9JvA8+OesvTPpl/KA51g0nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vF2i8ldmfvVQirprQN2PW38v/4lQD5dFlF7ixj3QVAb0h4RB5Zr1geiezZIsQEN8J
         ttqNCZhxaXaNUt6R38GSY6fRZ9Y4LPXnR/iDYgsHwvxkVXZdH/lyRMaKsubjj627wf
         uyRviSqM8Qo1ueQr1wl3Jw7H12Of3UTaZgBtDvII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 078/209] rpmsg: glink: smem: Support rx peak for size less than 4 bytes
Date:   Tue, 12 Nov 2019 20:48:14 -0500
Message-Id: <20191113015025.9685-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

[ Upstream commit 928002a5e9dab2ddc1a0fe3e00739e89be30dc6b ]

The current rx peak function fails to read the data if size is
less than 4bytes.

Use memcpy_fromio to support data reads of size less than 4 bytes.

Cc: stable@vger.kernel.org
Fixes: f0beb4ba9b18 ("rpmsg: glink: Remove chunk size word align warning")
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_smem.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_smem.c b/drivers/rpmsg/qcom_glink_smem.c
index 2b5cf27909540..7b6544348a3e0 100644
--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -89,15 +89,11 @@ static void glink_smem_rx_peak(struct qcom_glink_pipe *np,
 		tail -= pipe->native.length;
 
 	len = min_t(size_t, count, pipe->native.length - tail);
-	if (len) {
-		__ioread32_copy(data, pipe->fifo + tail,
-				len / sizeof(u32));
-	}
+	if (len)
+		memcpy_fromio(data, pipe->fifo + tail, len);
 
-	if (len != count) {
-		__ioread32_copy(data + len, pipe->fifo,
-				(count - len) / sizeof(u32));
-	}
+	if (len != count)
+		memcpy_fromio(data + len, pipe->fifo, (count - len));
 }
 
 static void glink_smem_rx_advance(struct qcom_glink_pipe *np,
-- 
2.20.1

