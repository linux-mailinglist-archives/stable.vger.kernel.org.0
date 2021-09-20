Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75015411CA2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347185AbhITRLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346966AbhITRJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D9D5617E4;
        Mon, 20 Sep 2021 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156983;
        bh=rd9RgKgMDnvaf5JL2e6oSAsgQngqMs2SuNiErx5e9XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfjL3XiPAkevmSxwi2/V/0ttX8YIg8ZF5bCMRVBf0cs+xTCGhkyO6V6j1ZJpsWTse
         JESIeFtul6BOP7J068z5uGhC/5jxtxBALLjbHcElx6NQY4Mg4GxupSkOgMKYdylliD
         cDRzMlNWsmEuToTCGDMJu/RJRWtfZOgSIzo8y/P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 144/175] ath9k: fix OOB read ar9300_eeprom_restore_internal
Date:   Mon, 20 Sep 2021 18:43:13 +0200
Message-Id: <20210920163922.781876367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 23151b9ae79e3bc4f6a0c4cd3a7f355f68dad128 ]

Bad header can have large length field which can cause OOB.
cptr is the last bytes for read, and the eeprom is parsed
from high to low address. The OOB, triggered by the condition
length > cptr could cause memory error with a read on
negative index.

There are some sanity check around length, but it is not
compared with cptr (the remaining bytes). Here, the
corrupted/bad EEPROM can cause panic.

I was able to reproduce the crash, but I cannot find the
log and the reproducer now. After I applied the patch, the
bug is no longer reproducible.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/YM3xKsQJ0Hw2hjrc@Zekuns-MBP-16.fios-router.home
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 7eff6f8023d8..969a2a581b0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3346,7 +3346,8 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 			"Found block at %x: code=%d ref=%d length=%d major=%d minor=%d\n",
 			cptr, code, reference, length, major, minor);
 		if ((!AR_SREV_9485(ah) && length >= 1024) ||
-		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485)) {
+		    (AR_SREV_9485(ah) && length > EEPROM_DATA_LEN_9485) ||
+		    (length > cptr)) {
 			ath_dbg(common, EEPROM, "Skipping bad header\n");
 			cptr -= COMP_HDR_LEN;
 			continue;
-- 
2.30.2



