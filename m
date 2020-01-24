Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B621482EB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbgAXLb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:31:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404146AbgAXLby (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:31:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 280CB20704;
        Fri, 24 Jan 2020 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865513;
        bh=qt282zMVZhy00/6FJGUXYspCVAel4YI0zVEb/a/ZS58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvHlNvTRqINWujRooJZZg8OgIo/KLKQNN4yQdE78UD2KyZ4oZRh6HHF+yWZPibTeO
         w5manspHfTFK+MSagytKtWh+z1UfqjoCUBoMLJ3JZ5IKnlse8npTlwg2xszJm7p0Id
         duhU27u52roRFhWDwSZYb0JyOAYibbOGWZPG6AbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 566/639] bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands
Date:   Fri, 24 Jan 2020 10:32:16 +0100
Message-Id: <20200124093200.262248675@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 57a8730b1f7a0be7bf8a0a0bb665329074ba764f ]

Firmware coredump messages take much longer than standard messages,
so increase the timeout accordingly.

Fixes: 6c5657d085ae ("bnxt_en: Add support for ethtool get dump.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f9e253b705ece..585f5aef0a45b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -527,6 +527,7 @@ struct rx_tpa_end_cmp_ext {
 #define DFLT_HWRM_CMD_TIMEOUT		500
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
+#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
 #define HWRM_RESP_ERR_CODE_MASK		0xffff
 #define HWRM_RESP_LEN_OFFSET		4
 #define HWRM_RESP_LEN_MASK		0xffff0000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index cdbb8940a4ae5..047024717d654 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2833,7 +2833,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 	req.component_id = cpu_to_le16(component_id);
 	req.segment_id = cpu_to_le16(segment_id);
 
-	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_COREDUMP_TIMEOUT);
 }
 
 static int bnxt_hwrm_dbg_coredump_retrieve(struct bnxt *bp, u16 component_id,
-- 
2.20.1



