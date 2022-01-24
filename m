Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB20F498F58
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348048AbiAXTwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43278 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356318AbiAXTpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:45:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD9A961298;
        Mon, 24 Jan 2022 19:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8216EC340E5;
        Mon, 24 Jan 2022 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053552;
        bh=H+uq4ZVZklWR33YUhdiDaf9uMY5fP9Hv3t8Qu8VlFXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYZTZPCFCHzHcQ0TOgS1tMiTtoMgRelFCq4zxyE4axTlD8XhvvqqwtHBy9mwThz8x
         KEq/1WST9x6qwDPXgwhVyLmexrK+Bw7hkgj/1iWe3WE/0MrQkZ0fi5ZtvI0Oq4qzYr
         +a5P7EoRypogWuTP1LcYJfERcFRtOmpgcfVAl+ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/563] crypto: qat - fix undetected PFVF timeout in ACK loop
Date:   Mon, 24 Jan 2022 19:37:46 +0100
Message-Id: <20220124184027.892805700@linuxfoundation.org>
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
index 7b34273d18937..74afafc84c716 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -132,6 +132,12 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
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
@@ -139,12 +145,6 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
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



