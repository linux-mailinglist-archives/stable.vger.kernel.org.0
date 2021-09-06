Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8084013B4
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbhIFB2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240632AbhIFB0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D7E76115C;
        Mon,  6 Sep 2021 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891351;
        bh=rZsRONI12SjSzXOZg7QF6TGdVrcr2bfAjtFda7Btl1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuE/sMOKuJ+x7w3c3LHGXmT+TdBcEkr0AZhYO8YSKgapmqaUzIJGJJDKQsU5tUTqJ
         UBlMc79b0FfS3HGkTsAJlBHKvE+V8NKQW2zYM6TlGy2qZkEHUucnoQhQdh9GaOXQjM
         ucg8qrOMRUrNKLifet52weGouMS7WbwAP7wzH4PNTU004lo36Ngiz9E7Cwk/4J/9A5
         XytfMdP0RqPwH6HaX7dEccpsZc+IAChK50JZeZ9PdrsZ1cIkKanlXDMzWlMQYdeQDg
         um5v/vhX6wrv76tKjYcgTLwEOLJlH/EDezNgttOXOamgOObsm1Qo69kcvMDClV5KK7
         JlrF2M93F+ASg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/39] crypto: qat - fix reuse of completion variable
Date:   Sun,  5 Sep 2021 21:21:44 -0400
Message-Id: <20210906012153.929962-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
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
index 8b090b7ae8c6..4c39731c51c8 100644
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

