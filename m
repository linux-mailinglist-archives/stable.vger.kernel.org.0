Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7A261457
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgIHQQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731685AbgIHQOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1599024901;
        Tue,  8 Sep 2020 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580408;
        bh=/EX9EiUO7EKKl32UqMlP7UBxy3ovcwPdEaANNdKgzLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyfX1PqibkKZLxa76f0MBAfZp3r7N2gwRPyUicV5yMfmrmxQ3zR4H5UQEENPfFjuf
         erbXqI2iUbEdjIDg8Lav/t4O1FQg1JBslQNrFPEFxumXYKuUeDFfpUDlMe8XoHWZpB
         wWZikezLBowxHksGQlvKQScEU/g458Y0WUsi0xuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 47/65] ALSA: ca0106: fix error code handling
Date:   Tue,  8 Sep 2020 17:26:32 +0200
Message-Id: <20200908152219.478862187@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

commit ee0761d1d8222bcc5c86bf10849dc86cf008557c upstream.

snd_ca0106_spi_write() returns 1 on error, snd_ca0106_pcm_power_dac()
is returning the error code directly, and the caller is expecting an
negative error code

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200824224541.1260307-1-ztong0001@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ca0106/ca0106_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -551,7 +551,8 @@ static int snd_ca0106_pcm_power_dac(stru
 		else
 			/* Power down */
 			chip->spi_dac_reg[reg] |= bit;
-		return snd_ca0106_spi_write(chip, chip->spi_dac_reg[reg]);
+		if (snd_ca0106_spi_write(chip, chip->spi_dac_reg[reg]) != 0)
+			return -ENXIO;
 	}
 	return 0;
 }


