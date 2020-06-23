Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67F9206324
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389350AbgFWUR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389608AbgFWURz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B822064B;
        Tue, 23 Jun 2020 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943475;
        bh=tWflFMXlPV/4i3zVv13EFFvXyfx9GgbxDS6WuLXF5YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmftUoK1nrEi9/NZbcGb/j+KUfb8SDPc+Pqsbg6vaQuG+8cfzBWSYitcyxVAHASO/
         te1XkmjcNuKF+hdgOUIwSLDugQPhCzIJbZ46NyTeR5hBTtLVLHUabyZzcoBfepOnYn
         lGKzaFq11fey6/N7hODJIzOCAeXFO7D7AO10LlNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 376/477] net: ipa: program upper nibbles of sequencer type
Date:   Tue, 23 Jun 2020 21:56:13 +0200
Message-Id: <20200623195425.303413691@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 636edeaad5577b6023f0de2b98a010d1cea73607 ]

The upper two nibbles of the sequencer type were not used for
SDM845, and were assumed to be 0.  But for SC7180 they are used, and
so they must be programmed by ipa_endpoint_init_seq().  Fix this bug.

IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP doesn't have a descriptive
comment, so add one.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 ++++--
 drivers/net/ipa/ipa_reg.h      | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a21534f1462fa..1d823ac0f6d61 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -669,10 +669,12 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
+	/* Sequencer type is made up of four nibbles */
 	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
 	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
-	/* HPS_REP_SEQ_TYPE is 0 */
-	/* DPS_REP_SEQ_TYPE is 0 */
+	/* The second two apply to replicated packets */
+	val |= u32_encode_bits((seq_type >> 8) & 0xf, HPS_REP_SEQ_TYPE_FMASK);
+	val |= u32_encode_bits((seq_type >> 12) & 0xf, DPS_REP_SEQ_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3b8106aa277a0..0a688d8c1d7cf 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -455,6 +455,8 @@ enum ipa_mode {
  *	second packet processing pass + no decipher + microcontroller
  * @IPA_SEQ_DMA_DEC:		DMA + cipher/decipher
  * @IPA_SEQ_DMA_COMP_DECOMP:	DMA + compression/decompression
+ * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
+ *	packet processing + no decipher + no uCP + HPS REP DMA parser
  * @IPA_SEQ_INVALID:		invalid sequencer type
  *
  * The values defined here are broken into 4-bit nibbles that are written
-- 
2.25.1



