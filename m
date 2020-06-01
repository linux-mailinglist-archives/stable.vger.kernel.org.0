Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C2F1EAB6F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgFASR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731397AbgFASRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042672068D;
        Mon,  1 Jun 2020 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035444;
        bh=JbbPvJtyCk3shIFPiMVQMDlP5b/tA6JQgsgUIxvcIuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJW7NKHN07eM8hDcblGkEEPMHtaxqR+QNBvn89mPBeF22Rqjyc6DoW3xKqdbeugbS
         8T2qAv2TfyoRAJ65NkQQQtDmgDBQCI+aF0Da3AQzdJJ1uSyDixYbcOF2NtiunRS9T5
         obobLuCONEbYO2dXwczKMokSPIr0WycT5ihB3Lyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 161/177] bnxt_en: fix firmware message length endianness
Date:   Mon,  1 Jun 2020 19:54:59 +0200
Message-Id: <20200601174101.682044771@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

commit 2a5a8800fa915bd9bc272c91ca64728e6aa84c0a upstream.

The explicit mask and shift is not the appropriate way to parse fields
out of a little endian struct. The length field is internally __le16
and the strategy employed only happens to work on little endian machines
because the offset used is actually incorrect (length is at offset 6).

Also remove the related and no longer used definitions from bnxt.h.

Fixes: 845adfe40c2a ("bnxt_en: Improve valid bit checking in firmware response message.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   14 ++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    5 -----
 2 files changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4184,14 +4184,12 @@ static int bnxt_hwrm_do_send_msg(struct
 	int i, intr_process, rc, tmo_count;
 	struct input *req = msg;
 	u32 *data = msg;
-	__le32 *resp_len;
 	u8 *valid;
 	u16 cp_ring_id, len = 0;
 	struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
 	struct hwrm_short_input short_input = {0};
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
-	u8 *resp_addr = (u8 *)bp->hwrm_cmd_resp_addr;
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
@@ -4209,7 +4207,6 @@ static int bnxt_hwrm_do_send_msg(struct
 		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
 		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
 		resp = bp->hwrm_cmd_kong_resp_addr;
-		resp_addr = (u8 *)bp->hwrm_cmd_kong_resp_addr;
 	}
 
 	memset(resp, 0, PAGE_SIZE);
@@ -4278,7 +4275,6 @@ static int bnxt_hwrm_do_send_msg(struct
 	tmo_count = HWRM_SHORT_TIMEOUT_COUNTER;
 	timeout = timeout - HWRM_SHORT_MIN_TIMEOUT * HWRM_SHORT_TIMEOUT_COUNTER;
 	tmo_count += DIV_ROUND_UP(timeout, HWRM_MIN_TIMEOUT);
-	resp_len = (__le32 *)(resp_addr + HWRM_RESP_LEN_OFFSET);
 
 	if (intr_process) {
 		u16 seq_id = bp->hwrm_intr_seq_id;
@@ -4306,9 +4302,8 @@ static int bnxt_hwrm_do_send_msg(struct
 					   le16_to_cpu(req->req_type));
 			return -EBUSY;
 		}
-		len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
-		      HWRM_RESP_LEN_SFT;
-		valid = resp_addr + len - 1;
+		len = le16_to_cpu(resp->resp_len);
+		valid = ((u8 *)resp) + len - 1;
 	} else {
 		int j;
 
@@ -4319,8 +4314,7 @@ static int bnxt_hwrm_do_send_msg(struct
 			 */
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
 				return -EBUSY;
-			len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
-			      HWRM_RESP_LEN_SFT;
+			len = le16_to_cpu(resp->resp_len);
 			if (len)
 				break;
 			/* on first few passes, just barely sleep */
@@ -4342,7 +4336,7 @@ static int bnxt_hwrm_do_send_msg(struct
 		}
 
 		/* Last byte of resp contains valid bit */
-		valid = resp_addr + len - 1;
+		valid = ((u8 *)resp) + len - 1;
 		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -654,11 +654,6 @@ struct nqe_cn {
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
 #define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
-#define HWRM_RESP_ERR_CODE_MASK		0xffff
-#define HWRM_RESP_LEN_OFFSET		4
-#define HWRM_RESP_LEN_MASK		0xffff0000
-#define HWRM_RESP_LEN_SFT		16
-#define HWRM_RESP_VALID_MASK		0xff000000
 #define BNXT_HWRM_REQ_MAX_SIZE		128
 #define BNXT_HWRM_REQS_PER_PAGE		(BNXT_PAGE_SIZE /	\
 					 BNXT_HWRM_REQ_MAX_SIZE)


