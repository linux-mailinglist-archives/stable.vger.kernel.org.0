Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5A40947A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbhIMOb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346884AbhIMO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD647615E2;
        Mon, 13 Sep 2021 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541046;
        bh=tQFJLeJ/jhMxCXwaPYSpw7IqLouZMpOiUpinMO2VLPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ep0v1zgwacnMveH1ekZX1qG2Ozj58jJ38xDJRQBsx+XOc3l4i5Y9qwrnpKEN0tKh6
         X7kEyerzJCxcuJoArsHQNtCfM5zzgeTNmEABrGQXW/Ea5br2/24LXMYmiVhjZ3woSz
         9fVGxFOEzRLM+hzA9ODN5hls6poeWlXCxXvND4Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <Alexander.Deucher@amd.com>,
        Changfeng Zhu <Changfeng.Zhu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 141/334] drm/amd/pm: Fix a bug in semaphore double-lock
Date:   Mon, 13 Sep 2021 15:13:15 +0200
Message-Id: <20210913131118.119819665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 544dcd74b7093ad4befac99b11d90331aa73348e ]

Fix a bug in smu_cmn_send_msg_without_waiting() in
that this function does not need to take the
smu->message_lock mutex in order to send a message
down to the SMU. The mutex is acquired by the
caller of this function instead.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Changfeng Zhu <Changfeng.Zhu@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Fixes: 5810323ba69289 ("drm/amd/pm: Fix a bug communicating with the SMU (v5)")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index a0e2111eb783..415be74df28c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -259,7 +259,6 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 	if (smu->adev->no_hw_access)
 		return 0;
 
-	mutex_lock(&smu->message_lock);
 	reg = __smu_cmn_poll_stat(smu);
 	res = __smu_cmn_reg2errno(smu, reg);
 	if (reg == SMU_RESP_NONE ||
@@ -269,7 +268,6 @@ int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
 	__smu_cmn_send_msg(smu, msg_index, param);
 	res = 0;
 Out:
-	mutex_unlock(&smu->message_lock);
 	return res;
 }
 
-- 
2.30.2



