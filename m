Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A70F2E687C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441791AbgL1QhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729894AbgL1NBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3104622583;
        Mon, 28 Dec 2020 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160473;
        bh=DKHJC+/0ys4+rCNYreoh+CGEH3RyDYelhl8jk1U5Txs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqY6FeBvHg2VepHkmCslFopPIehwsBotwkycA+b1eYHEVEHLsPtxF/sj67D0oytOm
         R1gS0afH8RgSMB1Hp1oBoP6Krybe96dGwvuuOrJB/FEsDvjMUdYCdkOayjnImNSHzd
         78/EWSJt9opXDaUyYYrv/43q6C7GYe+KnLobq3jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 064/175] RDMa/mthca: Work around -Wenum-conversion warning
Date:   Mon, 28 Dec 2020 13:48:37 +0100
Message-Id: <20201228124856.346209920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fbb7dc5db6dee553b5a07c27e86364a5223e244c ]

gcc points out a suspicious mixing of enum types in a function that
converts from MTHCA_OPCODE_* values to IB_WC_* values:

drivers/infiniband/hw/mthca/mthca_cq.c: In function 'mthca_poll_one':
drivers/infiniband/hw/mthca/mthca_cq.c:607:21: warning: implicit conversion from 'enum <anonymous>' to 'enum ib_wc_opcode' [-Wenum-conversion]
  607 |    entry->opcode    = MTHCA_OPCODE_INVALID;

Nothing seems to ever check for MTHCA_OPCODE_INVALID again, no idea if
this is meaningful, but it seems harmless as it deals with an invalid
input.

Remove MTHCA_OPCODE_INVALID and set the ib_wc_opcode to 0xFF, which is
still bogus, but at least doesn't make compiler warnings.

Fixes: 2a4443a69934 ("[PATCH] IB/mthca: fill in opcode field for send completions")
Link: https://lore.kernel.org/r/20201026211311.3887003-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_cq.c  | 2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index a5694dec3f2ee..098653b8157ed 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -609,7 +609,7 @@ static inline int mthca_poll_one(struct mthca_dev *dev,
 			entry->byte_len  = MTHCA_ATOMIC_BYTE_LEN;
 			break;
 		default:
-			entry->opcode    = MTHCA_OPCODE_INVALID;
+			entry->opcode = 0xFF;
 			break;
 		}
 	} else {
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 4393a022867ba..e1fc67e73bf87 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -105,7 +105,6 @@ enum {
 	MTHCA_OPCODE_ATOMIC_CS      = 0x11,
 	MTHCA_OPCODE_ATOMIC_FA      = 0x12,
 	MTHCA_OPCODE_BIND_MW        = 0x18,
-	MTHCA_OPCODE_INVALID        = 0xff
 };
 
 enum {
-- 
2.27.0



