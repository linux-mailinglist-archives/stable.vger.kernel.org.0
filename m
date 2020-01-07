Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D942613312E
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgAGU6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:57512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgAGU6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E1A208C4;
        Tue,  7 Jan 2020 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430703;
        bh=Xy+Q4NTl38ETxiR3FdkhofxfGl112xTRklj0RXpSHwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMyef+fw7lsXjZbeKBaMCksgYteGeJMz1oZ68qe+c2sdoWQEAVVN3GB5BuTyokwnd
         TCUJwE9oiZXzbv25EdLf6p2KQy18eK9wJdK5Bd5yXMDpAN3QZ1KmCt7gZmAevSV9GX
         FaCUt6nDk0SJpBOjeCwOrLYYuFgUbLPNmCh+UDBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b3028ac3933f5c466389@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/191] ALSA: hda - Downgrade error message for single-cmd fallback
Date:   Tue,  7 Jan 2020 21:53:02 +0100
Message-Id: <20200107205336.312492925@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 475feec0c41ad71cb7d02f0310e56256606b57c5 ]

We made the error message for the CORB/RIRB communication clearer by
upgrading to dev_WARN() so that user can notice better.  But this
struck us like a boomerang: now it caught syzbot and reported back as
a fatal issue although it's not really any too serious bug that worth
for stopping the whole system.

OK, OK, let's be softy, downgrade it to the standard dev_err() again.

Fixes: dd65f7e19c69 ("ALSA: hda - Show the fatal CORB/RIRB error more clearly")
Reported-by: syzbot+b3028ac3933f5c466389@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20191216151224.30013-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 6387c7e90918..76b507058cb4 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -884,7 +884,7 @@ static int azx_rirb_get_response(struct hdac_bus *bus, unsigned int addr,
 		return -EAGAIN; /* give a chance to retry */
 	}
 
-	dev_WARN(chip->card->dev,
+	dev_err(chip->card->dev,
 		"azx_get_response timeout, switching to single_cmd mode: last cmd=0x%08x\n",
 		bus->last_cmd[addr]);
 	chip->single_cmd = 1;
-- 
2.20.1



