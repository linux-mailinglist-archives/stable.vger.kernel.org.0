Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86811E2D06
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404271AbgEZTN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404264AbgEZTNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A93120888;
        Tue, 26 May 2020 19:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520404;
        bh=XvJDTNIF45o9UFGQKYua3tOzrBKSO1492EQJkze+mBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSfo6/N/jWFQguyr9yQzeamwDTmqm+3oF3Yq27pvCjUabQ4aTpju4mWmS34qqjZtp
         KPi01VIUXZKU0joC/nrWQZWraRKdLJ1X/yq1WA4FDuU5bGtCy8TPPGoab64aVCQqR9
         j22It7fWQ9gX59UA2O4jkhKzHuwzkFFyM5eLVTYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Bahling <sbahling@suse.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 064/126] ALSA: iec1712: Initialize STDSP24 properly when using the model=staudio option
Date:   Tue, 26 May 2020 20:53:21 +0200
Message-Id: <20200526183943.534486974@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 sound/pci/ice1712/ice1712.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2332,7 +2332,8 @@ static int snd_ice1712_chip_init(struct
 	pci_write_config_byte(ice->pci, 0x61, ice->eeprom.data[ICE_EEP1_ACLINK]);
 	pci_write_config_byte(ice->pci, 0x62, ice->eeprom.data[ICE_EEP1_I2SID]);
 	pci_write_config_byte(ice->pci, 0x63, ice->eeprom.data[ICE_EEP1_SPDIF]);
-	if (ice->eeprom.subvendor != ICE1712_SUBDEVICE_STDSP24) {
+	if (ice->eeprom.subvendor != ICE1712_SUBDEVICE_STDSP24 &&
+	    ice->eeprom.subvendor != ICE1712_SUBDEVICE_STAUDIO_ADCIII) {
 		ice->gpio.write_mask = ice->eeprom.gpiomask;
 		ice->gpio.direction = ice->eeprom.gpiodir;
 		snd_ice1712_write(ice, ICE1712_IREG_GPIO_WRITE_MASK,


