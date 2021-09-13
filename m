Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A684092FD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344522AbhIMOQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344738AbhIMOOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 288686142A;
        Mon, 13 Sep 2021 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540612;
        bh=Y3FiW/gGH0vnl8A8y1XkHDi0l9KZNCCAx7eMMF8pasQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBkVuEZRn31OvHeZ1rN6YgMevucXNpmfgsdyi6m+PU3InGL1OHzw87f7XpruadzHy
         R0pKpBzluyMrNAOaHh39AOn5e7RsRO+x2ymEIZEW3vGS5PiiNKd6jX1HHd/N4au3hQ
         nG6/iI592UGCYzNT2Xmjtl+W3FzaNa8fRBPipFGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Darren Powell <darren.powell@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 263/300] amdgpu/pm: add extra info to SMU msg pre-check failed message
Date:   Mon, 13 Sep 2021 15:15:24 +0200
Message-Id: <20210913131118.228798987@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darren Powell <darren.powell@amd.com>

[ Upstream commit 1e4a53de01c68d4ec9800b9a0f6efe9f26184a77 ]

Insert the value of the response to error message emitted when the
SMU msg pre-check failes

Signed-off-by: Darren Powell <darren.powell@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index dc7d2e71aa6f..5d1743f3321e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -104,8 +104,8 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 
 	ret = smu_cmn_wait_for_response(smu);
 	if (ret != 0x1) {
-		dev_err(adev->dev, "Msg issuing pre-check failed and "
-		       "SMU may be not in the right state!\n");
+		dev_err(adev->dev, "Msg issuing pre-check failed(0x%x) and "
+		       "SMU may be not in the right state!\n", ret);
 		if (ret != -ETIME)
 			ret = -EIO;
 		return ret;
-- 
2.30.2



