Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9212C937
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbfL2SCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbfL2RzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056EE21D7E;
        Sun, 29 Dec 2019 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642103;
        bh=PeiwkWgDs1/cNprP/Z76a9yEVI6kud9hO0A8oug8PWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehmLoN0dFwuQJ/FXk8e7VzQQDlARtfPWAo/2y5OQJBhH5gd/Fi4SRLLOyCrKeE45N
         bXdUx6LqPR/7TCFG5whwHJdu2uKjcwjKireWQIv7z7O1+59yv5Sf1lz5hPNuOvQ40O
         472bnJlY3DIGFC5c8oPuwAvnxM9S7LNpfMrZfB1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 326/434] bnxt_en: Return proper error code for non-existent NVM variable
Date:   Sun, 29 Dec 2019 18:26:19 +0100
Message-Id: <20191229172723.624091010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 05069dd4c577f9b143dfd243d55834333c4470c5 ]

For NVM params that are not supported in the current NVM
configuration, return the error as -EOPNOTSUPP.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 7151244f8c7d..7d2cfea05737 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -311,10 +311,17 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 	} else {
 		rc = hwrm_send_message_silent(bp, msg, msg_len,
 					      HWRM_CMD_TIMEOUT);
-		if (!rc)
+		if (!rc) {
 			bnxt_copy_from_nvm_data(val, data,
 						nvm_param.nvm_num_bits,
 						nvm_param.dl_num_bytes);
+		} else {
+			struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
+
+			if (resp->cmd_err ==
+				NVM_GET_VARIABLE_CMD_ERR_CODE_VAR_NOT_EXIST)
+				rc = -EOPNOTSUPP;
+		}
 	}
 	dma_free_coherent(&bp->pdev->dev, sizeof(*data), data, data_dma_addr);
 	if (rc == -EACCES)
-- 
2.20.1



