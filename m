Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF744012C3
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239258AbhIFBWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238903AbhIFBVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA6E61029;
        Mon,  6 Sep 2021 01:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891231;
        bh=GMdO6/NJpyqcf6PL78pSXI3sd5nYENoU1UOu6TmTrkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvqhUNjTGyKY/YzQwxQFZD9ua13zRf8JpiAUrBDwUC2Mo2lOAxm9twZxaVDjc54Pc
         wlz58hMLU4UTl3QiwQxZ+KxxMN8QT+oArJn7CxNTAyiQ4FiZRv/AV52z3h/eyq5Gxh
         2y6HHdDy2muVMA9FpBwZhjIiMct+AcTRq3ofbuh6/LW0DPZU651Evo35VZ4YY/7jew
         oXwGZs1z46BHcf4/uDxZ5JYuKn/Zr37gvCl6d4mn92W5gw36idxKwNPFKRrhtQ5Sdn
         8YwSeAiS0xOAT+7G0hrZct6N0lPAOhnMbyJFbmu8/5Na7cwBWMDGXS5hN4sD2D2S/Y
         HPV+iRd47qmRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 32/47] crypto: qat - fix reuse of completion variable
Date:   Sun,  5 Sep 2021 21:19:36 -0400
Message-Id: <20210906011951.928679-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906011951.928679-1-sashal@kernel.org>
References: <20210906011951.928679-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit 3d655732b0199562267a05c7ff69ecdd11632939 ]

Use reinit_completion() to set to a clean state a completion variable,
used to coordinate the VF to PF request-response flow, before every
new VF request.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index a1b77bd7a894..663638bb5c97 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -316,6 +316,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.30.2

