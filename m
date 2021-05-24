Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F93838EC4F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhEXPNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhEXPIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 745606191C;
        Mon, 24 May 2021 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867897;
        bh=hZJelB3zNRFZOwPJ8SOfGMyVUjlCrO4IOxyziMILlIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3jkwjzYasl9NLraNGFlGbl4HPFmIbM+lBd/Vb4BlUMtjzWaMEm5QLUnNQfoZA3tm
         vTOJVFKHV4h67mBAaDh/8BKlywysy5lOfsZO3ueRIpt9QNUMJmGvKLsnUcXVRftFcx
         O1wEf19/cSP/ZJ3qPBsbtJqAVdBA2lNBFYxgSFLs5CsP+QRKsEaz/MmHD91Xo1lBF/
         YTHErM2qxdPLkAZJVmlLjdnBDu744uk3KCKn3BJb66aWgwBmjtZ0SzJAIkVjoG7Hya
         39E1c5TS+X9ir9wf4Tk/kxIsee8hUV6QeQSnKKc655WI9aK3AbIMdNHzbvEEAe+Xpz
         O3RwM5kQtIogw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 05/16] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:51:19 -0400
Message-Id: <20210524145130.2499829-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

[ Upstream commit a28591f61b60fac820c6de59826ffa710e5e314e ]

The field "fm_res" of "struct snd_sb8" is never used/dereferenced
throughout the sb8.c code. Therefore there is no need for any null value
check after the "request_region()".

Add a comment note to make developers know about this and prevent any
"NULL check" patches on this part of code.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-36-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb8.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 0c7fe1418447..815639c04c52 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -109,7 +109,11 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
 	acard = card->private_data;
 	card->private_free = snd_sb8_free;
 
-	/* block the 0x388 port to avoid PnP conflicts */
+	/*
+	 * Block the 0x388 port to avoid PnP conflicts.
+	 * No need to check this value after request_region,
+	 * as we never do anything with it.
+	 */
 	acard->fm_res = request_region(0x388, 4, "SoundBlaster FM");
 	if (!acard->fm_res) {
 		err = -EBUSY;
-- 
2.30.2

