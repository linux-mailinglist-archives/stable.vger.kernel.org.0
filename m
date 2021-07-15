Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821703CAACE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbhGOTPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242883AbhGOTNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:13:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D4CC613CA;
        Thu, 15 Jul 2021 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376180;
        bh=N7e33y6QR5IO8WzBwu5PBaKOfG06Cc+AXdqz/izPRbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgCAf+fvZ/9wf2vteo3M6926v8SszKNBjMhyAQRbqTci5cCMLWxES49DLCLpMEYa4
         HKKw4kquf7kjkM1dqsjMJOJNM9pnj23dTzeGTlgaU1ysW+Qzjj6PlYfksP919uPTQs
         YIViFOmvGvDqOAtVg8iTdBYo8muvcQ8eCYtQDDA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miao-chen Chou <mcchou@chromium.org>,
        Yu Liu <yudiliu@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 159/266] Bluetooth: Fix the HCI to MGMT status conversion table
Date:   Thu, 15 Jul 2021 20:38:34 +0200
Message-Id: <20210715182640.884940891@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Liu <yudiliu@google.com>

[ Upstream commit 4ef36a52b0e47c80bbfd69c0cce61c7ae9f541ed ]

0x2B, 0x31 and 0x33 are reserved for future use but were not present in
the HCI to MGMT conversion table, this caused the conversion to be
incorrect for the HCI status code greater than 0x2A.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Yu Liu <yudiliu@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 023a98f7c992..0d86a62765d4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -252,12 +252,15 @@ static const u8 mgmt_status_table[] = {
 	MGMT_STATUS_TIMEOUT,		/* Instant Passed */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Pairing Not Supported */
 	MGMT_STATUS_FAILED,		/* Transaction Collision */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_INVALID_PARAMS,	/* Unacceptable Parameter */
 	MGMT_STATUS_REJECTED,		/* QoS Rejected */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Classification Not Supported */
 	MGMT_STATUS_REJECTED,		/* Insufficient Security */
 	MGMT_STATUS_INVALID_PARAMS,	/* Parameter Out Of Range */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_BUSY,		/* Role Switch Pending */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_FAILED,		/* Slot Violation */
 	MGMT_STATUS_FAILED,		/* Role Switch Failed */
 	MGMT_STATUS_INVALID_PARAMS,	/* EIR Too Large */
-- 
2.30.2



