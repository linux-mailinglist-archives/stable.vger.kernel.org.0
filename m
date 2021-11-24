Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE2F45BDA4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245470AbhKXMjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:39:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344161AbhKXMga (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:36:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0777F60295;
        Wed, 24 Nov 2021 12:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756515;
        bh=hBkzl/fBvpz534zxeQZnVJSm+nBHd2M1rJj7xY6iww8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT0kigXU2ju59VIofwQAUUC9958N4v2gl9ageAh4ajD/zWs7GQZgiyAY3YOGlIIA6
         7af9fLN91l9mRg34MyvSy4DGxhfv7V6kNHzS1X7Hjqi1QoVZw2j4AbZIM8qzZgDfOu
         OQx+gaK2LaQnqXnY7FZCccM3C4xhIJBaK32n9xqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 114/251] crypto: qat - disregard spurious PFVF interrupts
Date:   Wed, 24 Nov 2021 12:55:56 +0100
Message-Id: <20211124115714.188784226@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 72fd2bbbe704e..180016e157771 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -250,6 +250,11 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 
 	/* Read message from the VF */
 	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
+	if (!(msg & ADF_VF2PF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
+		goto out;
+	}
 
 	/* To ACK, clear the VF2PFINT bit */
 	msg &= ~ADF_VF2PF_INT;
@@ -333,6 +338,7 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 	if (resp && adf_iov_putmsg(accel_dev, resp, vf_nr))
 		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
 
+out:
 	/* re-enable interrupt on PF from this VF */
 	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_nr));
 	return;
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index ef90902c8200d..86274e3c6781d 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -123,6 +123,11 @@ static void adf_pf2vf_bh_handler(void *data)
 
 	/* Read the message from PF */
 	msg = ADF_CSR_RD(pmisc_bar_addr, hw_data->get_pf2vf_offset(0));
+	if (!(msg & ADF_PF2VF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious PF2VF interrupt, msg %X. Ignored\n", msg);
+		goto out;
+	}
 
 	if (!(msg & ADF_PF2VF_MSGORIGIN_SYSTEM))
 		/* Ignore legacy non-system (non-kernel) PF2VF messages */
@@ -171,6 +176,7 @@ static void adf_pf2vf_bh_handler(void *data)
 	msg &= ~ADF_PF2VF_INT;
 	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
 
+out:
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
 	return;
-- 
2.33.0



