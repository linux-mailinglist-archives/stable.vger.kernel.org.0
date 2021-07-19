Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354293CE460
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbhGSPn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347837AbhGSPjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C6861107;
        Mon, 19 Jul 2021 16:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711567;
        bh=PFPsC1bwNfkre24GbZAloHDyURgIzkgS9yrhCz7qWhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJLyNsR3+JONBFF4kW108IApp7fhKKIBSgu+2/xNawBEvpbMremJvJl5I95lfZTIM
         tgSNQ7BxJmHWnp7Xsdkj3fKXS0G2M/OkZUMLniF5aeCx1RLXkt9DpYx60Kdv3E56CA
         Y21OUbmIwUcA9PNw+ygTi7EPoBqByMcbe2PytW0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 051/292] ALSA: usx2y: Dont call free_pages_exact() with NULL address
Date:   Mon, 19 Jul 2021 16:51:53 +0200
Message-Id: <20210719144944.195916262@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit cae0cf651adccee2c3f376e78f30fbd788d0829f ]

Unlike some other functions, we can't pass NULL pointer to
free_pages_exact().  Add a proper NULL check for avoiding possible
Oops.

Link: https://lore.kernel.org/r/20210517131545.27252-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usb_stream.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c
index 091c071b270a..cff684942c4f 100644
--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -142,8 +142,11 @@ void usb_stream_free(struct usb_stream_kernel *sk)
 	if (!s)
 		return;
 
-	free_pages_exact(sk->write_page, s->write_size);
-	sk->write_page = NULL;
+	if (sk->write_page) {
+		free_pages_exact(sk->write_page, s->write_size);
+		sk->write_page = NULL;
+	}
+
 	free_pages_exact(s, s->read_size);
 	sk->s = NULL;
 }
-- 
2.30.2



