Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F60838EC37
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhEXPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:12:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhEXPGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8721561621;
        Mon, 24 May 2021 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867874;
        bh=Pr8LPc8GJmqXxJj0K724yClCixYI47VZAgKxceyl6lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzzA6bSX3PWvORom4zFipozKPm9ZrqZDwCu6D21d4cMILj9T1qD0dQJytzSwq0goh
         RtSGxaSVUzDQxi7QyMgp0iuZZsbRrMsqU/f0i0g6un3yQox3lu1VuXd1L5TTFZR4or
         iKibTAxr2LyOJS2jTg7bD/atOskaBdnDLzlDcc3ryTBo8RbpIgnTUndtM8x0tV+QPi
         9054LNdYCm4nTNiHxoe8SUUvaN0V6+Aq+zT8BWN+HCcNIVaiHnUecdsdcLtX3tun9c
         jnHkSAU3mYoxvAXafNQ23YXzZ4d/zR/wX01upyjFz6T0W3d8fRvoXf4pXWNZiaSboQ
         pLKd9AcgityGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 06/19] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:50:53 -0400
Message-Id: <20210524145106.2499571-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
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
index e75bfc511e3e..f7a7995588f2 100644
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

