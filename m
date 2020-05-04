Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74041C457B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgEDR6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729977AbgEDR6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 439D520707;
        Mon,  4 May 2020 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615128;
        bh=wbkp8qqavz27ErAdxGpNXAyCPktsf8JUg0achhI6Gds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bk9PNNUODumqxZGFZ3WiAnr1JafCPyi+2DJYuOsQo+6iJQl/UtoR90RodDvp/HJUb
         LBUrUMCxTKLvy5F1EpMdbybG3P9ICY7pdDBMu/1ejHEnC5A6P/Uo2S63nbQAhA6Qbg
         BHY+Kt2fz61qdcXNJrXh9bL2B2tPFa+bBVZwt99U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 07/18] ALSA: opti9xx: shut up gcc-10 range warning
Date:   Mon,  4 May 2020 19:57:05 +0200
Message-Id: <20200504165443.273457509@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 5ce00760a84848d008554c693ceb6286f4d9c509 upstream.

gcc-10 points out a few instances of suspicious integer arithmetic
leading to value truncation:

sound/isa/opti9xx/opti92x-ad1848.c: In function 'snd_opti9xx_configure':
sound/isa/opti9xx/opti92x-ad1848.c:322:43: error: overflow in conversion from 'int' to 'unsigned char' changes value from '(int)snd_opti9xx_read(chip, 3) & -256 | 240' to '240' [-Werror=overflow]
  322 |   (snd_opti9xx_read(chip, reg) & ~(mask)) | ((value) & (mask)))
      |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
sound/isa/opti9xx/opti92x-ad1848.c:351:3: note: in expansion of macro 'snd_opti9xx_write_mask'
  351 |   snd_opti9xx_write_mask(chip, OPTi9XX_MC_REG(3), 0xf0, 0xff);
      |   ^~~~~~~~~~~~~~~~~~~~~~
sound/isa/opti9xx/miro.c: In function 'snd_miro_configure':
sound/isa/opti9xx/miro.c:873:40: error: overflow in conversion from 'int' to 'unsigned char' changes value from '(int)snd_miro_read(chip, 3) & -256 | 240' to '240' [-Werror=overflow]
  873 |   (snd_miro_read(chip, reg) & ~(mask)) | ((value) & (mask)))
      |   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
sound/isa/opti9xx/miro.c:1010:3: note: in expansion of macro 'snd_miro_write_mask'
 1010 |   snd_miro_write_mask(chip, OPTi9XX_MC_REG(3), 0xf0, 0xff);
      |   ^~~~~~~~~~~~~~~~~~~

These are all harmless here as only the low 8 bit are passed down
anyway. Change the macros to inline functions to make the code
more readable and also avoid the warning.

Strictly speaking those functions also need locking to make the
read/write pair atomic, but it seems unlikely that anyone would
still run into that issue.

Fixes: 1841f613fd2e ("[ALSA] Add snd-miro driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200429190216.85919-1-arnd@arndb.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/isa/opti9xx/miro.c           |    9 ++++++---
 sound/isa/opti9xx/opti92x-ad1848.c |    9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -875,10 +875,13 @@ static void snd_miro_write(struct snd_mi
 	spin_unlock_irqrestore(&chip->lock, flags);
 }
 
+static inline void snd_miro_write_mask(struct snd_miro *chip,
+		unsigned char reg, unsigned char value, unsigned char mask)
+{
+	unsigned char oldval = snd_miro_read(chip, reg);
 
-#define snd_miro_write_mask(chip, reg, value, mask)	\
-	snd_miro_write(chip, reg,			\
-		(snd_miro_read(chip, reg) & ~(mask)) | ((value) & (mask)))
+	snd_miro_write(chip, reg, (oldval & ~mask) | (value & mask));
+}
 
 /*
  *  Proc Interface
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -327,10 +327,13 @@ static void snd_opti9xx_write(struct snd
 }
 
 
-#define snd_opti9xx_write_mask(chip, reg, value, mask)	\
-	snd_opti9xx_write(chip, reg,			\
-		(snd_opti9xx_read(chip, reg) & ~(mask)) | ((value) & (mask)))
+static inline void snd_opti9xx_write_mask(struct snd_opti9xx *chip,
+		unsigned char reg, unsigned char value, unsigned char mask)
+{
+	unsigned char oldval = snd_opti9xx_read(chip, reg);
 
+	snd_opti9xx_write(chip, reg, (oldval & ~mask) | (value & mask));
+}
 
 static int snd_opti9xx_configure(struct snd_opti9xx *chip,
 					   long port,


