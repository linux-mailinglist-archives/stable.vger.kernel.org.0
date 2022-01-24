Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74691499998
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357832AbiAXVga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378191AbiAXV1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF2FC01D7EB;
        Mon, 24 Jan 2022 12:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A780CB811FB;
        Mon, 24 Jan 2022 20:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FA7C340E5;
        Mon, 24 Jan 2022 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055536;
        bh=psjvXpRwbkh/FC73K7hFheviHZFeYgPuh5DJIAOlV/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltngI0tm8gNyIgF0XARc9PPXWDhO2ZtkmzXQFUSHpaD3Hj3S/9kr9tOcgFbCbBkOq
         h5wDYPQcMtRwkR0X/SByl/y/lKYBlSzRFGhGj8Ax3t/6lvqkaXBcbG3F2ROzn83kdh
         AAc/wBHPloUeI4GkEZuCyM/hbSb4rWXzR+z/+X+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/846] crypto: qat - fix undetected PFVF timeout in ACK loop
Date:   Mon, 24 Jan 2022 19:34:28 +0100
Message-Id: <20220124184106.206064962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 5002200b4fedd7e90e4fbc2e5c42a4b3351df814 ]

If the remote function did not ACK the reception of a message, the
function __adf_iov_putmsg() could detect it as a collision.

This was due to the fact that the collision and the timeout checks after
the ACK loop were in the wrong order. The timeout must be checked at the
end of the loop, so fix by swapping the order of the two checks.

Fixes: 9b768e8a3909 ("crypto: qat - detect PFVF collision after ACK")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d5a7261ddd928..7ec81989beb03 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -138,6 +138,12 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	} while ((val & int_bit) && (count++ < ADF_IOV_MSG_ACK_MAX_RETRY));
 
+	if (val & int_bit) {
+		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
+		val &= ~int_bit;
+		ret = -EIO;
+	}
+
 	if (val != msg) {
 		dev_dbg(&GET_DEV(accel_dev),
 			"Collision - PFVF CSR overwritten by remote function\n");
@@ -145,12 +151,6 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		goto out;
 	}
 
-	if (val & int_bit) {
-		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
-		val &= ~int_bit;
-		ret = -EIO;
-	}
-
 	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
 out:
-- 
2.34.1



