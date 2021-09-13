Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33376408EBE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbhIMNgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243008AbhIMNeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:34:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74C9461159;
        Mon, 13 Sep 2021 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539615;
        bh=hjQhBHugbas3U+Bwmf2ThCON0nO041MwaWie5WG/8b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiZsfG/O+Ht+buOIddJry1S4rFuBwbEVssoamogT/FRfR2IS+Sam19f5h4xN71+jQ
         E2xgw3vK0j9+lIJXosy9VqZy0zmFo8NsLA1aAw7i3y7iXMVGW8l7qdrTZCpnNyHkNG
         DS2SpVPR2g3fSPEk4q64uaHto9Quw4LIemcGPch8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/236] media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init
Date:   Mon, 13 Sep 2021 15:13:16 +0200
Message-Id: <20210913131103.450371211@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c5453769f77ce19a5b03f1f49946fd3f8a374009 ]

If dibusb_read_eeprom_byte fails, the mac address is not initialized.
And nova_t_read_mac_address does not handle this failure, which leads to
the uninit-value in dvb_usb_adapter_dvb_init.

Fix this by handling the failure of dibusb_read_eeprom_byte.

Reported-by: syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com
Fixes: 786baecfe78f ("[media] dvb-usb: move it to drivers/media/usb/dvb-usb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/nova-t-usb2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index e7b290552b66..9c0eb0d40822 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -130,7 +130,7 @@ ret:
 
 static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 {
-	int i;
+	int i, ret;
 	u8 b;
 
 	mac[0] = 0x00;
@@ -139,7 +139,9 @@ static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
 
 	/* this is a complete guess, but works for my box */
 	for (i = 136; i < 139; i++) {
-		dibusb_read_eeprom_byte(d,i, &b);
+		ret = dibusb_read_eeprom_byte(d, i, &b);
+		if (ret)
+			return ret;
 
 		mac[5 - (i - 136)] = b;
 	}
-- 
2.30.2



