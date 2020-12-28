Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3612E3C8F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437306AbgL1OEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437302AbgL1OEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7054206D4;
        Mon, 28 Dec 2020 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164214;
        bh=0/ZqALBnNmKoH+sFsadT8YvHXeWiPgEg7lSdxLv5SKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GH+NN1A8ARowwBhkq72Kll+1tm8DYYwYJQNrH/TUWqc+yKHzI985SVAEf2EYlCQMn
         utmnaF2Zft8DmFGyofB7BCuFKZVpbYh3YCyHCRVo9hRgHz6dYhx113bq0L19TPZjRn
         rMkawtO1HVcPSIPzr/33pRf85uM6GUi4q8Xvn5EQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/717] RDMa/mthca: Work around -Wenum-conversion warning
Date:   Mon, 28 Dec 2020 13:41:39 +0100
Message-Id: <20201228125025.814154903@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 119b2573c9a08..26c3408dcacae 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -604,7 +604,7 @@ static inline int mthca_poll_one(struct mthca_dev *dev,
 			entry->byte_len  = MTHCA_ATOMIC_BYTE_LEN;
 			break;
 		default:
-			entry->opcode    = MTHCA_OPCODE_INVALID;
+			entry->opcode = 0xFF;
 			break;
 		}
 	} else {
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 9dbbf4d16796a..a445160de3e16 100644
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



