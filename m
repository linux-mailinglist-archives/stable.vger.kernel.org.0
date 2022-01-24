Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3936499410
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357323AbiAXUil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385517AbiAXUd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF816C07E2A1;
        Mon, 24 Jan 2022 11:45:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2C1B811F9;
        Mon, 24 Jan 2022 19:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F8C340E5;
        Mon, 24 Jan 2022 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053546;
        bh=Hf36ntOYAnKrh82bMACnxeu8gNHCeUCilXw7+onLIuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvloL0rqGFmtYY2Nb2rQfe54ESQocfr5+M65dvmGgHItY5fcb86QBw/pgPoS4nffO
         cnpeNI03GJ6/MDkJqRbnwFTkpusml8Z/FyLyD41AfRlGkf8PIRuNHV+sI/Lg+3hToJ
         9qJ+p898kRoDbj7wb4EZ50Lw5nn/y0aqlPxayJE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/563] crypto: qat - remove unnecessary collision prevention step in PFVF
Date:   Mon, 24 Jan 2022 19:37:44 +0100
Message-Id: <20220124184027.824746602@linuxfoundation.org>
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

[ Upstream commit e17f49bb244a281fe39bfdad0306a38b3a02e7bf ]

The initial version of the PFVF protocol included an initial "carrier
sensing" to get ownership of the channel.

Collisions can happen anyway, the extra wait and test does not prevent
collisions, it instead slows the communication down, so remove it.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index e3da97286980e..d1dbf6216de57 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -120,28 +120,10 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		goto out;
 	}
 
-	/* Attempt to get ownership of PF2VF CSR */
 	msg &= ~local_in_use_mask;
 	msg |= local_in_use_pattern;
-	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg);
 
-	/* Wait in case remote func also attempting to get ownership */
-	msleep(ADF_IOV_MSG_COLLISION_DETECT_DELAY);
-
-	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
-	if ((val & local_in_use_mask) != local_in_use_pattern) {
-		dev_dbg(&GET_DEV(accel_dev),
-			"PF2VF CSR in use by remote - collision detected\n");
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/*
-	 * This function now owns the PV2VF CSR.  The IN_USE_BY pattern must
-	 * remain in the PF2VF CSR for all writes including ACK from remote
-	 * until this local function relinquishes the CSR.  Send the message
-	 * by interrupting the remote.
-	 */
+	/* Attempt to get ownership of the PF2VF CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
 
 	/* Wait for confirmation from remote func it received the message */
-- 
2.34.1



