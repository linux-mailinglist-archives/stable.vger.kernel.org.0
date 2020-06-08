Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787631F2D61
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgFIAc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbgFHXPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D64521532;
        Mon,  8 Jun 2020 23:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658103;
        bh=sQjkPKrlL5V6DRjrdXB0ZI0gV62k+bpSQLHdQ/3cqXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdalPhSvWtKyZq43qt3WTeXBnz/PflSmIamaw8Nfcv3DW2YMJTcbjeDpI+xsG8pKu
         buUBOF9eZPvQSkH3KmerDzKcZtvZxge0qmcoQ1iuk2mBCCdm8VNH3NJ9LP+o1MCS/k
         F2maAZrc00dGcMGZwaSZ3DG1hh64BuwXxbLow1To=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Bahling <sbahling@suse.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 143/606] ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option
Date:   Mon,  8 Jun 2020 19:04:28 -0400
Message-Id: <20200608231211.3363633-143-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Bahling <sbahling@suse.com>

commit b0cb099062b0c18246c3a20caaab4c0afc303255 upstream.

The ST Audio ADCIII is an STDSP24 card plus extension box. With commit
e8a91ae18bdc ("ALSA: ice1712: Add support for STAudio ADCIII") we
enabled the ADCIII ports using the model=staudio option but forgot
this part to ensure the STDSP24 card is initialized properly.

Fixes: e8a91ae18bdc ("ALSA: ice1712: Add support for STAudio ADCIII")
Signed-off-by: Scott Bahling <sbahling@suse.com>
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1048934
Link: https://lore.kernel.org/r/20200518175728.28766-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ice1712/ice1712.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 884d0cdec08c..73e1e5400506 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2332,7 +2332,8 @@ static int snd_ice1712_chip_init(struct snd_ice1712 *ice)
 	pci_write_config_byte(ice->pci, 0x61, ice->eeprom.data[ICE_EEP1_ACLINK]);
 	pci_write_config_byte(ice->pci, 0x62, ice->eeprom.data[ICE_EEP1_I2SID]);
 	pci_write_config_byte(ice->pci, 0x63, ice->eeprom.data[ICE_EEP1_SPDIF]);
-	if (ice->eeprom.subvendor != ICE1712_SUBDEVICE_STDSP24) {
+	if (ice->eeprom.subvendor != ICE1712_SUBDEVICE_STDSP24 &&
+	    ice->eeprom.subvendor != ICE1712_SUBDEVICE_STAUDIO_ADCIII) {
 		ice->gpio.write_mask = ice->eeprom.gpiomask;
 		ice->gpio.direction = ice->eeprom.gpiodir;
 		snd_ice1712_write(ice, ICE1712_IREG_GPIO_WRITE_MASK,
-- 
2.25.1

