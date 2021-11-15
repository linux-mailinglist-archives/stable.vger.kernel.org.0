Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68D452676
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350836AbhKPCFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239585AbhKOSDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E7A6334E;
        Mon, 15 Nov 2021 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997885;
        bh=zPgemiYMLS9FW9uQAs6BaeEbjY5O+4QDfROo06PaKhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rU/TLaGAteySGeYvFjk07rpy3OwxQcvW0moBrf8IWhTSq9YxdYEyF9iZXo2bb9Pz9
         IqO03QJS3ps0I+chXkkrgyFI6cBQ5H1UDKAn9XNdNsw2YEwRP92ZvqD7MHK0gQAtty
         eCIXXEdeDwQ5RfYlZaxwi4oI0gmT9TZuGwiYh9HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/575] crypto: qat - disregard spurious PFVF interrupts
Date:   Mon, 15 Nov 2021 18:00:35 +0100
Message-Id: <20211115165354.509249993@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index a5bd77d0f0487..d7ca222f0df18 100644
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
index 024401ec9d1ae..fa1b3a94155cc 100644
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



