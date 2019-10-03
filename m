Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A3ECAC5B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfJCQJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbfJCQJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CCA222BE;
        Thu,  3 Oct 2019 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118943;
        bh=vaMMPoKAfHhldi0winWWmJRpYRh/kQDxIZEj1PKaLew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vc0opHWcn0pX5KHGjmqsr3whjKMpxgbKoQ+apwWB9tLxHxeejJsdAgHMwPMV6gNXL
         9tZGuh6bE0SIs0PjszmMbbillOmnWDF2VQR5xOTulyasssvZcuKfKB0w72Q3bjGneK
         zA6+QB+cKk6dwXCcW6z9DhDCa8cg/mb8G/KHDl0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 067/185] ALSA: hda - Show the fatal CORB/RIRB error more clearly
Date:   Thu,  3 Oct 2019 17:52:25 +0200
Message-Id: <20191003154452.660838079@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index a41c1bec7c88c..8fcb421193e02 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -877,10 +877,13 @@ static int azx_rirb_get_response(struct hdac_bus *bus, unsigned int addr,
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



