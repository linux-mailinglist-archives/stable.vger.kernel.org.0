Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99AF3F640A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhHXRAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238843AbhHXQ7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB42B61407;
        Tue, 24 Aug 2021 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824246;
        bh=qOpZ2WkZCrX1yf1K35+6Pi3teojoh/oXtDy65VxztZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpsnhkNKiSSJ/cmHMEzis95ooXxMfqti1U2MBvS4DcjVRxWHs2KLkte06Z4NMl312
         BO45nleTJILoO4TIbIOdFb+YUCNIpj4fS2/P6gHQaKY2kHWZuo0YFzGC8n9+24rHqh
         XA4wMQRF5RstCcTK0H9hUZOR29qURrKhWqFkcfBH8MRX4w1vIQ1EHbX50sbfXGSMng
         RdSwvPuuvOrsGfTPeanP+wTTuVfsiP/mIjn8Sc3TBEFBYTqrAlLSztgL0apYQWQtZj
         9lKuY5OY2gOZSjT/ZsmzROUp90ZBujAEba1p0V21BjZ8jJHjPySumgaqitIDciHTVk
         KK9iExH3bzuJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/127] r8152: fix the maximum number of PLA bp for RTL8153C
Date:   Tue, 24 Aug 2021 12:55:19 -0400
Message-Id: <20210824165607.709387-80-sashal@kernel.org>
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

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 6633fb83f1faddbfcac09e35edcae96bd0468335 ]

The maximum PLA bp number of RTL8153C is 16, not 8. That is, the
bp 0 ~ 15 are at 0xfc28 ~ 0xfc46, and the bp_en is at 0xfc48.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b2b77edf72b8..a044f37e87ae 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3953,13 +3953,24 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_06:
 		ocp_write_byte(tp, type, PLA_BP_EN, 0);
 		break;
+	case RTL_VER_14:
+		ocp_write_word(tp, type, USB_BP2_EN, 0);
+
+		ocp_write_word(tp, type, USB_BP_8, 0);
+		ocp_write_word(tp, type, USB_BP_9, 0);
+		ocp_write_word(tp, type, USB_BP_10, 0);
+		ocp_write_word(tp, type, USB_BP_11, 0);
+		ocp_write_word(tp, type, USB_BP_12, 0);
+		ocp_write_word(tp, type, USB_BP_13, 0);
+		ocp_write_word(tp, type, USB_BP_14, 0);
+		ocp_write_word(tp, type, USB_BP_15, 0);
+		break;
 	case RTL_VER_08:
 	case RTL_VER_09:
 	case RTL_VER_10:
 	case RTL_VER_11:
 	case RTL_VER_12:
 	case RTL_VER_13:
-	case RTL_VER_14:
 	case RTL_VER_15:
 	default:
 		if (type == MCU_TYPE_USB) {
@@ -4329,7 +4340,6 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 		case RTL_VER_11:
 		case RTL_VER_12:
 		case RTL_VER_13:
-		case RTL_VER_14:
 		case RTL_VER_15:
 			fw_reg = 0xf800;
 			bp_ba_addr = PLA_BP_BA;
@@ -4337,6 +4347,13 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 			bp_start = PLA_BP_0;
 			max_bp = 8;
 			break;
+		case RTL_VER_14:
+			fw_reg = 0xf800;
+			bp_ba_addr = PLA_BP_BA;
+			bp_en_addr = USB_BP2_EN;
+			bp_start = PLA_BP_0;
+			max_bp = 16;
+			break;
 		default:
 			goto out;
 		}
-- 
2.30.2

