Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497CC3C2CEF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhGJCVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhGJCVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9CA5613D4;
        Sat, 10 Jul 2021 02:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883500;
        bh=PFPsC1bwNfkre24GbZAloHDyURgIzkgS9yrhCz7qWhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfsWRSp6k0s49iQlCtbq8eddqUpaU47Gmu0SzSFlaooXckgTf+YQ6rhHYN0Ym0heG
         vLKnzZw9BbPodip1bkeDyDTM2Bkl9DtFbfvmpR4qNxlCpLbMUadsObGklscGaJs2jT
         GruUgmMVsjLFbzsYqem/yFEFR7pDqvSXjsIliV9P+LypTr3tuJMFKS3SDP2Rzf6pvk
         jrO5K/9aWXl8ADLTVADiMqWYczdZAwhNDh3JO+TnrscL4G7Bq+nvnTXIoDOXCRgG4N
         P4FDkbL6x+UiAKwZjzj06dxusfex6VFNdmrjFJGv4csjFLV/56EXjFBe6FuYXEvrlR
         yBeR6Oe3ledDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 022/114] ALSA: usx2y: Don't call free_pages_exact() with NULL address
Date:   Fri,  9 Jul 2021 22:16:16 -0400
Message-Id: <20210710021748.3167666-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
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

