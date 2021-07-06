Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D683BCEAA
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhGFL04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhGFLXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC9161CF5;
        Tue,  6 Jul 2021 11:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570288;
        bh=eKX49emukDMwE44pP/xuqP89fE1fH4GYou94kjiKakc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+BnkE0R+N0eQKZAfv446Qyttf9ONnp+ZoCfVVsNK7ii5XJpEDf4ZZ6b2rA5fiaPA
         lTdYPk9BOHEU/D3OIlR6jCqFb+g4C0CsN2MeHS5v7aSdWGpgOBneHuRGohg2WmMYiB
         lChgugUOb9vEXr+tfoueXxBd/WnQIBTE5K1m5i/l+MF11+Ewnhc2jKIYmMT74DUwJG
         /4Sg9j2bWj//nLM9roDt2jtGqNU8xZVXroAu3dz6cMKOAtSv7EnjgoSEQvm9sC5gFo
         Ne/ZaJXmq2Xnr/AM01Oz1GFwC8OM+22MRg/wpqMQKyV/AwrdzoQDcjSKQSHu6YzzO1
         EElfSFZ/xPBCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hilda Wu <hildawu@realtek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 178/189] Bluetooth: btusb: Add support USB ALT 3 for WBS
Date:   Tue,  6 Jul 2021 07:13:58 -0400
Message-Id: <20210706111409.2058071-178-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 90872099d9c3..4c18a85a1070 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1751,6 +1751,13 @@ static void btusb_work(struct work_struct *work)
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

