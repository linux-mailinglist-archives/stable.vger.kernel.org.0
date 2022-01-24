Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1CE49940D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351139AbiAXUif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385516AbiAXUda (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39031C07E2A2;
        Mon, 24 Jan 2022 11:45:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B14006135E;
        Mon, 24 Jan 2022 19:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD30FC340E5;
        Mon, 24 Jan 2022 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053549;
        bh=bMP6poSSRt5WVXutbv5fXRkoaoHGAUitGkuYuUN9upE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdvIJ/e3Z4M0nIMlPm+bvqhJHgmOcDQzOPSpYvZ7kQXGQSjfZ0NLNi9O2ePmpS19Y
         B6zHB5tmKeNuFPNrkniNlP7zpItpZT/t0Pkp9zhNXbppX7q5edZ6Tb8WG7vod/HBGJ
         jmyGN5pfFiP2ejHrGebKfF+M1jGj3y3mv+7niVdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/563] crypto: qat - make pfvf send message direction agnostic
Date:   Mon, 24 Jan 2022 19:37:45 +0100
Message-Id: <20220124184027.856214978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit 6e680f94bc31d0fd0ff01123c964d895ea8040fa ]

The functions adf_iov_putmsg() and __adf_iov_putmsg() are shared by both
PF and VF. Any logging or documentation should not refer to any specific
direction.

Make comments and log messages direction agnostic by replacing PF2VF
with PFVF. Also fix the wording for some related comments.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d1dbf6216de57..7b34273d18937 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -111,11 +111,11 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	mutex_lock(lock);
 
-	/* Check if PF2VF CSR is in use by remote function */
+	/* Check if the PFVF CSR is in use by remote function */
 	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
 		dev_dbg(&GET_DEV(accel_dev),
-			"PF2VF CSR in use by remote function\n");
+			"PFVF CSR in use by remote function\n");
 		ret = -EBUSY;
 		goto out;
 	}
@@ -123,7 +123,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	msg &= ~local_in_use_mask;
 	msg |= local_in_use_pattern;
 
-	/* Attempt to get ownership of the PF2VF CSR */
+	/* Attempt to get ownership of the PFVF CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
 
 	/* Wait for confirmation from remote func it received the message */
@@ -145,7 +145,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		ret = -EIO;
 	}
 
-	/* Finished with PF2VF CSR; relinquish it and leave msg in CSR */
+	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
 out:
 	mutex_unlock(lock);
@@ -153,12 +153,13 @@ out:
 }
 
 /**
- * adf_iov_putmsg() - send PF2VF message
+ * adf_iov_putmsg() - send PFVF message
  * @accel_dev:  Pointer to acceleration device.
  * @msg:	Message to send
- * @vf_nr:	VF number to which the message will be sent
+ * @vf_nr:	VF number to which the message will be sent if on PF, ignored
+ *		otherwise
  *
- * Function sends a message from the PF to a VF
+ * Function sends a message through the PFVF channel
  *
  * Return: 0 on success, error code otherwise.
  */
-- 
2.34.1



