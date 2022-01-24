Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2486749971F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446848AbiAXVJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:09:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58150 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343668AbiAXVFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909EE60B28;
        Mon, 24 Jan 2022 21:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73449C340E5;
        Mon, 24 Jan 2022 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058334;
        bh=IXvHj7ag7A4+SqD1sdKZ1WXEP0mkxaXoEEPyd+zXsEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy96po9LsKgR34jz7lR5etnZsSl2jaArpNG70T4Zxg2Unn0uxT0XnFZhf3j3Ga+zM
         0OXIfe6W/0L4enXdS/okhwz1WuE3Jtpf3BLyWIbELE/mf2w1mWYv/KsojeGA5egk7B
         9KD+2Ms2twznq/eWGZqbCBwn6i1JNsQjrH6fUkJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seevalamuthu Mariappan <quic_seevalam@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0255/1039] ath11k: Fix QMI file type enum value
Date:   Mon, 24 Jan 2022 19:34:04 +0100
Message-Id: <20220124184133.888375036@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seevalamuthu Mariappan <quic_seevalam@quicinc.com>

[ Upstream commit 18ae1ab04525507ae5528245a6df004cacd0d39a ]

bdf_type for caldata in QMI_WLANFW_BDF_DOWNLOAD_REQ_V01 is wrongly
sent as 1. But, expected bdf_type value for caldata and EEPROM is 2 and 3
respectively. It leads to firmware crash. Fix ath11k_qmi_file_type enum
values.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-00192-QCAHKSWPL_SILICONZ-1

Fixes: 336e7b53c82f ("ath11k: clean up BDF download functions")
Signed-off-by: Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/1638182754-18408-1-git-send-email-quic_seevalam@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.h b/drivers/net/wireless/ath/ath11k/qmi.h
index 3bb0f9ef79968..d9e95b7007653 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.h
+++ b/drivers/net/wireless/ath/ath11k/qmi.h
@@ -41,7 +41,7 @@ struct ath11k_base;
 
 enum ath11k_qmi_file_type {
 	ATH11K_QMI_FILE_TYPE_BDF_GOLDEN,
-	ATH11K_QMI_FILE_TYPE_CALDATA,
+	ATH11K_QMI_FILE_TYPE_CALDATA = 2,
 	ATH11K_QMI_FILE_TYPE_EEPROM,
 	ATH11K_QMI_MAX_FILE_TYPE,
 };
-- 
2.34.1



