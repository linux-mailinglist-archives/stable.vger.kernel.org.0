Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842F7CA1AB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfJCP6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfJCP6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:58:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E23820830;
        Thu,  3 Oct 2019 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118297;
        bh=+/ggtlj+xPS8v3mnbHptst9iFj5utmAfBdLGqH5i4lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VK9g2ZFsvCIdE6U8ce5pT0a2ZTYEwOBT19mYquoDgNGAuv8RS5BhKgH4b8Mje/6TC
         h0+qoTkvZtlDMPEnrTDrYcAjjoZdD6pxR7sOQSqRs9PUZnmwojzfuxCANVT39yTRxv
         nYIoBRB4mcXzLOg9GlPdiXAnBqqqYnazsTnrC4is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 43/99] ALSA: hda - Show the fatal CORB/RIRB error more clearly
Date:   Thu,  3 Oct 2019 17:53:06 +0200
Message-Id: <20191003154316.351539452@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dd65f7e19c6961ba6a69f7c925021b7a270cb950 ]

The last fallback of CORB/RIRB communication error recovery is to turn
on the single command mode, and this last resort usually means that
something is really screwed up.  Instead of a normal dev_err(), show
the error more clearly with dev_WARN() with the caller stack trace.

Also, show the bus-reset fallback also as an error, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 273364c39171c..9cdf86f04e037 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -667,10 +667,13 @@ static int azx_rirb_get_response(struct hdac_bus *bus, unsigned int addr,
 	 */
 	if (hbus->allow_bus_reset && !hbus->response_reset && !hbus->in_reset) {
 		hbus->response_reset = 1;
+		dev_err(chip->card->dev,
+			"No response from codec, resetting bus: last cmd=0x%08x\n",
+			bus->last_cmd[addr]);
 		return -EAGAIN; /* give a chance to retry */
 	}
 
-	dev_err(chip->card->dev,
+	dev_WARN(chip->card->dev,
 		"azx_get_response timeout, switching to single_cmd mode: last cmd=0x%08x\n",
 		bus->last_cmd[addr]);
 	chip->single_cmd = 1;
-- 
2.20.1



