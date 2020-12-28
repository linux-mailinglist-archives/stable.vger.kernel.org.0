Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EF42E65BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbgL1N0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389090AbgL1N0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C6922AAA;
        Mon, 28 Dec 2020 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161941;
        bh=y7Mf1UPmifAMkf+SOqsQYtEqkkYTZRtWBfVzYkzGhLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrbEW0lR6X3KsTTRHercUz5ggT/ad1hfTsEnyB9kbP/PPN/cUYY2Sr3JZDVNasBlG
         7gf+4pKZPELImLaRDV+3/nticcq7hYLMUR86sSeAPUDH5LBDnzDUkw6WB2i2fnbmJP
         l5AVLRivmXVknqF9QoSMGJaojGngpKuaEQ6SxIhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/346] RDMa/mthca: Work around -Wenum-conversion warning
Date:   Mon, 28 Dec 2020 13:47:34 +0100
Message-Id: <20201228124926.315947835@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 220a3e4717a35..e23575861f287 100644
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



