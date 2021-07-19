Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5563CDD71
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245248AbhGSO57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244548AbhGSO5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA7361375;
        Mon, 19 Jul 2021 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708879;
        bh=HHXKvtBZLV1ygGrqo7mH1V8f8ZtZsNbbpfa4QL6BnUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C069pYRaK7qfFLmpCe4ZCR2umjy/MXFT+/Z/UduUhOT+7Mbge6nB+s3c2oc247obO
         X/2PpHCfF9lxnjybYqBqHQpDuzG6ZpfgRYVMQnWo6Z67CwePJBrTDkoXsnfXC/w4TY
         WP6Q79EWKdfrMd71ML4ye58jtsqyTNuvworglCHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/421] mwifiex: re-fix for unaligned accesses
Date:   Mon, 19 Jul 2021 16:49:37 +0200
Message-Id: <20210719144952.195754122@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8f4e3d48bb50765ab27ae5bebed2595b20de80a1 ]

A patch from 2017 changed some accesses to DMA memory to use
get_unaligned_le32() and similar interfaces, to avoid problems
with doing unaligned accesson uncached memory.

However, the change in the mwifiex_pcie_alloc_sleep_cookie_buf()
function ended up changing the size of the access instead,
as it operates on a pointer to u8.

Change this function back to actually access the entire 32 bits.
Note that the pointer is aligned by definition because it came
from dma_alloc_coherent().

Fixes: 92c70a958b0b ("mwifiex: fix for unaligned reads")
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5907b34037c2..2f0141c964e2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1084,7 +1084,7 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	u32 tmp;
+	u32 *cookie;
 
 	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
 						     &card->sleep_cookie_pbase);
@@ -1093,13 +1093,11 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 			    "pci_alloc_consistent failed!\n");
 		return -ENOMEM;
 	}
+	cookie = (u32 *)card->sleep_cookie_vbase;
 	/* Init val of Sleep Cookie */
-	tmp = FW_AWAKE_COOKIE;
-	put_unaligned(tmp, card->sleep_cookie_vbase);
+	*cookie = FW_AWAKE_COOKIE;
 
-	mwifiex_dbg(adapter, INFO,
-		    "alloc_scook: sleep cookie=0x%x\n",
-		    get_unaligned(card->sleep_cookie_vbase));
+	mwifiex_dbg(adapter, INFO, "alloc_scook: sleep cookie=0x%x\n", *cookie);
 
 	return 0;
 }
-- 
2.30.2



