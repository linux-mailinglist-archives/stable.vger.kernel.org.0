Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD23BD160
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhGFLjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236930AbhGFLfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A1E61C4C;
        Tue,  6 Jul 2021 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570689;
        bh=PRo/Fu32AZoF4I/2I/N3l1HZZrfOyedE5Wm8/jp3H2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xbj+xTuVZDoci+eFs5gYDzcwbOmBO/+79Om+n1gLCCs3/dIdCMYq5HRI1c30KDt5y
         2cr4zs/H8IRNYBY3QSapqwC+YIcb6PbHaJnhOqYmGedy/rZy0Bsc6SGSgN9AqTw29O
         aGRgTbg9aCOLbD6v324UcTO26UbjXeWOO7MTaX3yoIVRCclB8Io6AxryoBG0xXJ0/O
         tjLDQX7MnNK8cNPYjEyKoDOC9IVkAlsf1VFfD7zBgwEBpNPw4onavwpx6SivRJ4ZCh
         BwRAYBeyiZGtu3rbT78IpvCpYZ+riHeSC+mcshZ0NEQRyoMb6Oghb5EZ7R3dAfnJXw
         1IbileeJeCwNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hilda Wu <hildawu@realtek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 128/137] Bluetooth: btusb: Add support USB ALT 3 for WBS
Date:   Tue,  6 Jul 2021 07:21:54 -0400
Message-Id: <20210706112203.2062605-128-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit e848dbd364aca44c9d23c04bef964fab79e2b34f ]

Because mSBC frames do not need to be aligned to the SCO packet
boundary. Using USB ALT 3 let HCI payload >= 60 bytes, let mSBC
data satisfy 60 Bytes avoid payload unaligned situation and fixed
some headset no voise issue.

USB Alt 3 supported also need HFP support transparent MTU in 72 Bytes.

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8f38a2a7da8c..b3c63e06838d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1721,6 +1721,13 @@ static void btusb_work(struct work_struct *work)
 			 * which work with WBS at all.
 			 */
 			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
+			/* Because mSBC frames do not need to be aligned to the
+			 * SCO packet boundary. If support the Alt 3, use the
+			 * Alt 3 for HCI payload >= 60 Bytes let air packet
+			 * data satisfy 60 bytes.
+			 */
+			if (new_alts == 1 && btusb_find_altsetting(data, 3))
+				new_alts = 3;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
-- 
2.30.2

