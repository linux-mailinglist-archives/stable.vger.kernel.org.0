Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8B3C2F90
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhGJCbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233968AbhGJCaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3372613CC;
        Sat, 10 Jul 2021 02:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884041;
        bh=PFPsC1bwNfkre24GbZAloHDyURgIzkgS9yrhCz7qWhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqZMpD81TyRUzQNI1aiI5xTyc3zQKKa5Eu6pXEIJlXuzeyobCZ91Y/m1AXbVclXg4
         3KfEjyZhlIyocdm+7ZqvDCw605pm3ocIN9Y5bQY40/QbJ1LUNMPpgx7hO/2Zf8bb5U
         EwgaZ9pkREU8m/e+DAIDa9m1Aee+6ZiDmJr00rdTHICqO2Xq37QZNnFfpFxfbS+5Ls
         3hKL1Ku7P/2wMCyo1Yd0F4ZHEitVWiEUi6Q4I3komne8fol3Vr6faUKHlnJYSTs6vu
         GNRjchnSq27XqXUGbCoRJFRwtbbvwZSIv8aiTxfZPL3Aj/pl4FHb4lzr8gegB69rLd
         BbNyOS4NUYr+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 09/63] ALSA: usx2y: Don't call free_pages_exact() with NULL address
Date:   Fri,  9 Jul 2021 22:26:15 -0400
Message-Id: <20210710022709.3170675-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

