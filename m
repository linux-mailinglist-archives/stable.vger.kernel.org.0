Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8833CAAFF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbhGOTQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244828AbhGOTPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D5DE61412;
        Thu, 15 Jul 2021 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376288;
        bh=eKX49emukDMwE44pP/xuqP89fE1fH4GYou94kjiKakc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhad0xc2jlIcHPl95wVQ1UgRA/sQD6Ks5BAVpotvlp42sXg0EGRcHTy1boE4/cqCQ
         0TWtYSWozNIP8C8AxLE2QrirGroBmwmx0KZT37m548vfvROxuRhmrt3MrDQ/qO+DHZ
         D91UeZ6harnRKiQ7xMSOVbWF6e5Nkb60MKE4C2ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 165/266] Bluetooth: btusb: Add support USB ALT 3 for WBS
Date:   Thu, 15 Jul 2021 20:38:40 +0200
Message-Id: <20210715182641.680914783@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



