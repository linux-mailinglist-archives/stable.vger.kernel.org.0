Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1738A48B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhETKGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235046AbhETKBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4DAC613C7;
        Thu, 20 May 2021 09:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503575;
        bh=3hkc2ps3l3rA61gkvCZxOktPrH8DBjtxE4/mQt4na/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEvWAn04TV0etd97VzAA66YajXu4EyAO49sJz2JJ2v4qSdCOxHS9nX6dl4+i2amzB
         F6e58jCet2/A8gXcioEVr+sn0jPZE2Gy7JwiSwmMu6vWvehBuSCmre/VdeiF2S9A84
         2iFTuWSNw5/MEBMBhz2AZOdllBZsDbSTT1aopt8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 282/425] ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices
Date:   Thu, 20 May 2021 11:20:51 +0200
Message-Id: <20210520092140.712918602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 7dd9a40fd6e0d0f1fd8e1931c007e080801dfdce ]

When the error check in ath9k_hw_read_revisions() was added, it checked for
-EIO which is what ath9k_regread() in the ath9k_htc driver uses. However,
for plain ath9k, the register read function uses ioread32(), which just
returns -1 on error. So if such a read fails, it still gets passed through
and ends up as a weird mac revision in the log output.

Fix this by changing ath9k_regread() to return -1 on error like ioread32()
does, and fix the error check to look for that instead of -EIO.

Fixes: 2f90c7e5d094 ("ath9k: Check for errors when reading SREV register")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210326180819.142480-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 27d9fe6799f5..cb136d9d4621 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -246,7 +246,7 @@ static unsigned int ath9k_regread(void *hw_priv, u32 reg_offset)
 	if (unlikely(r)) {
 		ath_dbg(common, WMI, "REGISTER READ FAILED: (0x%04x, %d)\n",
 			reg_offset, r);
-		return -EIO;
+		return -1;
 	}
 
 	return be32_to_cpu(val);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b4f7ee423d40..9f438d8e59f2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -287,7 +287,7 @@ static bool ath9k_hw_read_revisions(struct ath_hw *ah)
 
 	srev = REG_READ(ah, AR_SREV);
 
-	if (srev == -EIO) {
+	if (srev == -1) {
 		ath_err(ath9k_hw_common(ah),
 			"Failed to read SREV register");
 		return false;
-- 
2.30.2



