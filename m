Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129A816764E
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbgBUILW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732675AbgBUILU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D7820578;
        Fri, 21 Feb 2020 08:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272680;
        bh=kLfit3+l6JmuMoFIOggjqVIq/2lixWIxyIbQSNqbNQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8+jt0UgRF/JbvQpxiCkRC/CqEaGkFzENR5TcJjlrDaWSOuCJCp5L9qm4zSFY8trj
         ixKRuPOKro3E8t63fsp94qTl2gHBRfYR3GIZpalEqm0OYJCFaz7iGMMINma3N+qjHu
         RjSZDDt/0ygMCzlk34xUwzUBefwSdc3gpZlh94S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/344] ALSA: usb-audio: unlock on error in probe
Date:   Fri, 21 Feb 2020 08:40:34 +0100
Message-Id: <20200221072410.646085992@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a3afa29942b84b4e2548beacccc3a68b8d77e3dc ]

We need to unlock before we returning on this error path.

Fixes: 73ac9f5e5b43 ("ALSA: usb-audio: Add boot quirk for MOTU M Series")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200115174604.rhanfgy4j3uc65cx@kili.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index e6a618a239948..54f9ce38471e6 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -599,7 +599,7 @@ static int usb_audio_probe(struct usb_interface *intf,
 	if (! chip) {
 		err = snd_usb_apply_boot_quirk_once(dev, intf, quirk, id);
 		if (err < 0)
-			return err;
+			goto __error;
 
 		/* it's a fresh one.
 		 * now look for an empty slot and create a new card instance
-- 
2.20.1



