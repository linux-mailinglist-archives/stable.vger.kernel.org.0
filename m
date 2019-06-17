Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2EF49247
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfFQVSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbfFQVSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:18:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E2322133F;
        Mon, 17 Jun 2019 21:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806326;
        bh=wQZM3Ik/52vbVSoWrHiMtLVPsypW3LSzIgzoAQwEykY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niY8kAEVVLvQaH4j4mckLaeD/Ymsh6gw6SkoGj6KHIiFY0mKhOub5wLxBFt0RoCk/
         yBfiycOxweaCf6ftZeGcrFMxaYMYZda8tUjJiZKwXOyb547ODBNYOZu7mjfpii8Y3A
         1P38qRG1MQC57rB6pUo+wbcnlO6Q/Nyb302Qm/bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Nuno Capela <rncbc@rncbc.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 014/115] ALSA: ice1712: Check correct return value to snd_i2c_sendbytes (EWS/DMX 6Fire)
Date:   Mon, 17 Jun 2019 23:08:34 +0200
Message-Id: <20190617210800.656483627@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Nuno Capela <rncbc@rncbc.org>

commit 352bcae97f9ba87801f497571cdec20af190efe1 upstream.

Check for exact and correct return value to snd_i2c_sendbytes
call for EWS/DMX 6Fire (snd_ice1712).

Fixes a systemic error on every boot starting from kernel 5.1
onwards to snd_ice1712 driver ("cannot send pca") on Terratec
EWS/DMX 6Fire PCI soundcards.

Check for exact and correct return value to snd_i2c_sendbytes
call for EWS/DMX 6Fire (snd_ice1712).

Fixes a systemic error on every boot to snd_ice1712 driver
("cannot send pca") on Terratec EWS/DMX 6Fire PCI soundcards.

Fixes: c99776cc4018 ("ALSA: ice1712: fix a missing check of snd_i2c_sendbytes")
Signed-off-by: Rui Nuno Capela <rncbc@rncbc.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ice1712/ews.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ice1712/ews.c
+++ b/sound/pci/ice1712/ews.c
@@ -826,7 +826,7 @@ static int snd_ice1712_6fire_read_pca(st
 
 	snd_i2c_lock(ice->i2c);
 	byte = reg;
-	if (snd_i2c_sendbytes(spec->i2cdevs[EWS_I2C_6FIRE], &byte, 1)) {
+	if (snd_i2c_sendbytes(spec->i2cdevs[EWS_I2C_6FIRE], &byte, 1) != 1) {
 		snd_i2c_unlock(ice->i2c);
 		dev_err(ice->card->dev, "cannot send pca\n");
 		return -EIO;


