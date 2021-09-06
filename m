Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D740401454
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbhIFBcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351420AbhIFBa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B85961154;
        Mon,  6 Sep 2021 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891424;
        bh=6UmB6ykUfxJtqzo3qnDcVnv31GjeZXUQrxUoahVRJAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XktC3KRHnf2iiGzqUX4oL8IdS7GnzkctXCN7yokA1Azl66+6Yqd0+8Zrxh+5dKM/7
         6xvJryp8fxdGI2YisLQ+YMJgZ60Pr7YQ7itjECYquCifTCygqTfeUuh+6qnjigKJ/5
         yUf2UiVSv4vR+kr3AAYktYypgwqylsDJqlp7PE8O1DSki6sQ/aZCjc6VRXek+zfbQT
         7AUnfuAraI34a/A3OQpwhLlpmLxB5Qg8OHcUXfd71SOLP5rxxVVBwsXnbSD9RwZicS
         0h05Ybe3zBVcblTsm2GfUV3KgMEP6K9QQlFSi0v3MUbes+JOW91zdsCjCnY8xQqVMc
         4RVa/F30YClDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/23] crypto: qat - do not ignore errors from enable_vf2pf_comms()
Date:   Sun,  5 Sep 2021 21:23:16 -0400
Message-Id: <20210906012322.930668-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 5147f0906d50a9d26f2b8698cd06b5680e9867ff ]

The function adf_dev_init() ignores the error code reported by
enable_vf2pf_comms(). If the latter fails, e.g. the VF is not compatible
with the pf, then the load of the VF driver progresses.
This patch changes adf_dev_init() so that the error code from
enable_vf2pf_comms() is returned to the caller.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 26556c713049..7a7d43c47534 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -105,6 +105,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int ret;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -171,9 +172,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 
 	hw_data->enable_error_correction(accel_dev);
-	hw_data->enable_vf2pf_comms(accel_dev);
+	ret = hw_data->enable_vf2pf_comms(accel_dev);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_dev_init);
 
-- 
2.30.2

