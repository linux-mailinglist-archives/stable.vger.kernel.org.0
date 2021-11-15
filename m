Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7A645244E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351730AbhKPBhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242974AbhKOSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4107061A52;
        Mon, 15 Nov 2021 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999755;
        bh=Nn9ssULzPUCploX5CFpswWpDIMS4lw7GjM2kXRCWTRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0QsM9zNn8O1pKEAA6D0Jrc9B/+bA42Gwg2Zg/kUq+kRp2n+XLsqmozpcw5r+waS4
         JW4hn0lPQh9G6Q6RpefLVlxy/iK882CEBJzHV/GD9Hmj9YtnzAWYaeGekaK3dpdTIG
         OiGYSY2Ufufm/OwVypvtxLnIRwUuXwde/8fWMITc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 412/849] crypto: qat - detect PFVF collision after ACK
Date:   Mon, 15 Nov 2021 17:58:15 +0100
Message-Id: <20211115165434.196486957@linuxfoundation.org>
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

[ Upstream commit 9b768e8a3909ac1ab39ed44a3933716da7761a6f ]

Detect a PFVF collision between the local and the remote function by
checking if the message on the PFVF CSR has been overwritten.
This is done after the remote function confirms that the message has
been received, by clearing the interrupt bit, or the maximum number of
attempts (ADF_IOV_MSG_ACK_MAX_RETRY) to check the CSR has been exceeded.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index efa4bffb4f601..bb479c577ce23 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -150,6 +150,13 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	} while ((val & int_bit) && (count++ < ADF_IOV_MSG_ACK_MAX_RETRY));
 
+	if (val != msg) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Collision - PFVF CSR overwritten by remote function\n");
+		ret = -EIO;
+		goto out;
+	}
+
 	if (val & int_bit) {
 		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
 		val &= ~int_bit;
-- 
2.33.0



