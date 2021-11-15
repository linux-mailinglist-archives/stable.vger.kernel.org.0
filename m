Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14D3452455
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbhKPBhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242976AbhKOSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C711633B4;
        Mon, 15 Nov 2021 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999758;
        bh=RHgKu4fumDwkrBKfPcsRX8dKXFk5Hs272dusSPPbQj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTmQ/MU7jZboq5ZkcPy3dULjiztqt7dzlGCH0wJkI2V7II1r2XGlBB5HZTCwE4PWH
         MyV+Ldm3NRh74OMbbbBwBMUDFUVfKfT8Oh/vPCE0z5PiI8UpkC0P0PefbOBbWMLzR4
         7v2GeMtCgHiQiSLVjVOA49oZ6MvQI5VsEAZgfQaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 413/849] crypto: qat - disregard spurious PFVF interrupts
Date:   Mon, 15 Nov 2021 17:58:16 +0100
Message-Id: <20211115165434.232108196@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 18fcba469ba5359c1de7e3fb16f7b9e8cd1b8e02 ]

Upon receiving a PFVF message, check if the interrupt bit is set in the
message. If it is not, that means that the interrupt was probably
triggered by a collision. In this case, disregard the message and
re-enable the interrupts.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 6 ++++++
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index bb479c577ce23..e3da97286980e 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -205,6 +205,11 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 
 	/* Read message from the VF */
 	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
+	if (!(msg & ADF_VF2PF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
+		goto out;
+	}
 
 	/* To ACK, clear the VF2PFINT bit */
 	msg &= ~ADF_VF2PF_INT;
@@ -288,6 +293,7 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 	if (resp && adf_iov_putmsg(accel_dev, resp, vf_nr))
 		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
 
+out:
 	/* re-enable interrupt on PF from this VF */
 	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_nr));
 	return;
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 3e4f64d248f9b..35e952092b4a8 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -79,6 +79,11 @@ static void adf_pf2vf_bh_handler(void *data)
 
 	/* Read the message from PF */
 	msg = ADF_CSR_RD(pmisc_bar_addr, hw_data->get_pf2vf_offset(0));
+	if (!(msg & ADF_PF2VF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious PF2VF interrupt, msg %X. Ignored\n", msg);
+		goto out;
+	}
 
 	if (!(msg & ADF_PF2VF_MSGORIGIN_SYSTEM))
 		/* Ignore legacy non-system (non-kernel) PF2VF messages */
@@ -127,6 +132,7 @@ static void adf_pf2vf_bh_handler(void *data)
 	msg &= ~ADF_PF2VF_INT;
 	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
 
+out:
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
 	return;
-- 
2.33.0



