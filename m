Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0869640141A
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbhIFBcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241608AbhIFB3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F10561132;
        Mon,  6 Sep 2021 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891394;
        bh=3Mmiju3sdqsKuvmqlxTn/k9pgMEyNG4h1nHPX3kcYFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4y+C7QhzaGjaDNi8bwEGUzs3Qzgr0iJkV9OvvRc0KLyWBU3qYhS8XkYx1PsiP2KJ
         D5Wh3QN0YQaFhAudFR2QvczIlKC3gLx8FudxRJRKHT4OgONA/MHqdgStnQr/I9rZox
         ilFtwt4ATB90tlPgo7GEy61r0UwYy/8Lm0gGhKiFeA7KAiV73EhFafzQ6tyhWLZUVm
         25n/vexQ26K16H3pJuprUekhd1pRNrL1W5/DBIPV25QulscjSnPi5KXK8WxuiLZByq
         YVCfMkNyan8jLlwbLSOPBmQchGAgi/+PDnIlqYQYFdIciC/F8J+Ot0UVtdY6zw2gIR
         Y/tvz6cGRMvVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/30] crypto: qat - fix reuse of completion variable
Date:   Sun,  5 Sep 2021 21:22:37 -0400
Message-Id: <20210906012244.930338-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012244.930338-1-sashal@kernel.org>
References: <20210906012244.930338-1-sashal@kernel.org>
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
index b3875fdf6cd7..9dab2cc11fdf 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -361,6 +361,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.30.2

