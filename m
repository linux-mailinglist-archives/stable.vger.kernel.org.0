Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32E138EB88
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhEXPD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233842AbhEXPB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E6AB61492;
        Mon, 24 May 2021 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867816;
        bh=03uit3HcRgBQorQUpuon9ip1oRKD6umUP7MMKYqtLKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vErcjlfxXSZknkqa3o/4mxdaf/IEBQZlVhwiDq+kbR3igRJxX0+5+kWHng5Nu4M6k
         k4DlkjhfHeloLFeJlcIQdoIzaBP3eBzhjvxQlxjD2LDe3V3TYQp3cQSu7U/OaPDmpF
         8GP0gj/YkgCLOozl+j7PdRIsx5qQ4iyuy5BqMgJXHbXn19rvrTVu37ZqpcxPUtq73X
         0jakNzDMgFJccRBEtn/Cz9ismMqdqSTnNjzDFdQlEIVz30nI6/zyfbUHZ63cx9HOxU
         2JrfYit6VQhzZy4ESnaHMWST4Z1au8SZWfsRsvUpMd8BTDJ3BTHvhhhY5TkhR0Udxw
         ZadLtSlLm0QcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 06/25] ALSA: sb8: Add a comment note regarding an unused pointer
Date:   Mon, 24 May 2021 10:49:49 -0400
Message-Id: <20210524145008.2499049-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
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
index 1eb8b61a185b..fb59e5179075 100644
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

