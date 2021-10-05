Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B602D422840
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhJENtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235133AbhJENt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0BC614C8;
        Tue,  5 Oct 2021 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633441656;
        bh=Tb0S7mTTVay5g/OLWemkKqRtK+aoDy54rLQE7qsW9Bg=;
        h=Subject:To:From:Date:From;
        b=dztCKmTiP4gyvx8OordKiMKTR0JmVBEcUKkbBfXXkfbyzLUPy9BqsCI22odwbJ6lY
         DAofV57aYLs/CigHygJmaJVLqo/16RFyhPgJNo5qnHcnRc5NMwJFfri98xDcITtbF0
         Jod3HMldF+gxsLRUV8BMrPp8zsBNMkjCnND7zOwM=
Subject: patch "misc: gehc: Add SPI ID table" added to char-misc-linus
To:     broonie@kernel.org, gregkh@linuxfoundation.org,
        martyn.welch@collabora.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 15:47:33 +0200
Message-ID: <163344165312614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: gehc: Add SPI ID table

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a3e16937319aea285c64ab5bf8464470afac8dd3 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Thu, 23 Sep 2021 20:46:09 +0100
Subject: misc: gehc: Add SPI ID table

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI ID table entry
for the device name part of the compatible - currently only the full
compatible is listed which isn't very idiomatic and won't match the
modalias that is generated.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Cc: stable <stable@vger.kernel.org>
Tested-by: Martyn Welch <martyn.welch@collabora.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210923194609.52647-1-broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/gehc-achc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/gehc-achc.c b/drivers/misc/gehc-achc.c
index 02f33bc60c56..4c9c5394da6f 100644
--- a/drivers/misc/gehc-achc.c
+++ b/drivers/misc/gehc-achc.c
@@ -539,6 +539,7 @@ static int gehc_achc_probe(struct spi_device *spi)
 
 static const struct spi_device_id gehc_achc_id[] = {
 	{ "ge,achc", 0 },
+	{ "achc", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(spi, gehc_achc_id);
-- 
2.33.0


