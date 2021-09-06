Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48844013B6
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbhIFB2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhIFB0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACBE061159;
        Mon,  6 Sep 2021 01:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891352;
        bh=7PuyXQHJTX62uj4QleCzjQ/pAMnyV+SrpgOeeeBFsts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeArUl/hpOF11LpfAXwDwutf+InSvbEHb2Nyny6kcYxhZmbIFQ9OZT8kLy0IGNLVj
         sLxSO7b2Ck2JqjuP2Igtbqzcsy07Jmdug3DvRj9rdB6JLaY3xTToApxSrsxXPTSPUv
         a+hxy/cpoQfNskxHmD9GfUKaubppDWwftuE7EsUE5ahOUAfv1jCpUoCoRP2vWqKYFe
         xrsjDzihw2Ol05/5G42Gcq8tZx40U9CHdgkNA2Qfc1ZR90qmvw+K9PgMGkjJ8sLf4j
         1XQxch5XW3XMxLS02zDtBmdJ8u1uFxQpbshJB8J4TdAiZdoqI6SKjIUB2MljU5AVOm
         k4m1GBFqAM+kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/39] crypto: qat - fix naming for init/shutdown VF to PF notifications
Date:   Sun,  5 Sep 2021 21:21:45 -0400
Message-Id: <20210906012153.929962-31-sashal@kernel.org>
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

[ Upstream commit b90c1c4d3fa8cd90f4e8245b13564380fd0bfad1 ]

At start and shutdown, VFs notify the PF about their state. These
notifications are carried out through a message exchange using the PFVF
protocol.

Function names lead to believe they do perform init or shutdown logic.
This is to fix the naming to better reflect their purpose.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c |  4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c   |  4 ++--
 drivers/crypto/qat/qat_common/adf_common_drv.h       |  8 ++++----
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c        | 12 ++++++------
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c      |  4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index d2fedbd7113c..9709f29b6454 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -79,10 +79,10 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 29fd3f1091ab..5e6909d6cfc6 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -79,10 +79,10 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index f22342f612c1..469e06c93faf 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -195,8 +195,8 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
@@ -219,12 +219,12 @@ static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
 
-static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 2c98fb63f7b7..54b738da829d 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -5,14 +5,14 @@
 #include "adf_pf2vf_msg.h"
 
 /**
- * adf_vf2pf_init() - send init msg to PF
+ * adf_vf2pf_notify_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends an init messge from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -25,17 +25,17 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_init);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
 
 /**
- * adf_vf2pf_shutdown() - send shutdown msg to PF
+ * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends a shutdown messge from the VF to a PF
  *
  * Return: void
  */
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -45,4 +45,4 @@ void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send Shutdown event to PF\n");
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 5246f0524ca3..fc4cf141b1de 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -79,10 +79,10 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
-- 
2.30.2

