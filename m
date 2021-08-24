Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4B3F63B7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhHXQ55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234778AbhHXQ50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3203F6138B;
        Tue, 24 Aug 2021 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824201;
        bh=3Ivn0NdOQlS7/R3oobsU5roqVSIfAAoYr0ZRFzKsBh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upqnfQIMrCEIBgD8udZh7l+Zx+CYf+Rd68czwA1BeG6seVaPDdm6muvtr9tuMJ/0T
         l+5E4aJ8TglEbJ2xBqyiWOgYLyh/1aMCzN0eLYw2+ok27OTv0ylbxLk48Kr0AtTqRf
         O6iVDo0z4Lc7YrZJxUnkyrQjy4wUNGGkkg7T4Kv7+37GZMiRH+yG87WxMbh6O/SKEG
         wNXILsfaXZkWDzsKfeQSKSdqtjIVln0sce9KcRuBojQXGlAaDA9WACVYNWkD2eCS7t
         X8iHTnOY3MR7rr1yQulD+wfZIZJf81ckFa97paAPFYNjtEgdzf3REHIDrjwfMGaVVg
         jT8YZGghrwHWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 034/127] mt76: fix enum type mismatch
Date:   Tue, 24 Aug 2021 12:54:34 -0400
Message-Id: <20210824165607.709387-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit abf3d98dee7c4038152ce88833ddc2189f68cbd4 ]

There is no 'NONE' version of 'enum mcu_cipher_type', and returning
'MT_CIPHER_NONE' causes a warning:

drivers/net/wireless/mediatek/mt76/mt7921/mcu.c: In function 'mt7921_mcu_get_cipher':
drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:114:24: error: implicit conversion from 'enum mt76_cipher_type' to 'enum mcu_cipher_type' [-Werror=enum-conversion]
  114 |                 return MT_CIPHER_NONE;
      |                        ^~~~~~~~~~~~~~

Add the missing MCU_CIPHER_NONE defintion that fits in here with
the same value.

Fixes: c368362c36d3 ("mt76: fix iv and CCMP header insertion")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210721150745.1914829-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h | 3 ++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 607980321d27..106177072d18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -111,7 +111,7 @@ mt7915_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 517621044d9e..c0255c3ac7d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -1035,7 +1035,8 @@ enum {
 };
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 47843b055959..fc0d7dc3a5f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -111,7 +111,7 @@ mt7921_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index 07abe86f07a9..adad20819341 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -198,7 +198,8 @@ struct sta_rec_sec {
 } __packed;
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
-- 
2.30.2

