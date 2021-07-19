Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272473CDA46
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbhGSOfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244579AbhGSOeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2D3E61002;
        Mon, 19 Jul 2021 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707608;
        bh=MvPgqGi4tTT5o/ehOAay5tYuvqFudz92RH0/8OHz31k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFrqwQlA9uoqt/paG8FRMbPmqq2OF5eFUMhYBo6ExJEb6OflRTXjsuEQHwF9I+z0i
         vBJtI0QQ5BYhrak4jgcroVd9m4RAbnthchN+8N1WBSn054ROJ0/DacTzZjUzwP+2kt
         ASthgXGrKLtjrHRa1njOvl20jCZjLkOGOZHc077o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 232/245] ALSA: isa: Fix error return code in snd_cmi8330_probe()
Date:   Mon, 19 Jul 2021 16:52:54 +0200
Message-Id: <20210719144947.882384930@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 31028cbed26a8afa25533a10425ffa2ab794c76c ]

When 'SB_HW_16' check fails, the error code -ENODEV instead of 0 should be
returned, which is the same as that returned when 'WSS_HW_CMI8330' check
fails.

Fixes: 43bcd973d6d0 ("[ALSA] Add snd_card_set_generic_dev() call to ISA drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210707074051.2663-1-thunder.leizhen@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/cmi8330.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index dfedfd85f205..463906882b95 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -564,7 +564,7 @@ static int snd_cmi8330_probe(struct snd_card *card, int dev)
 	}
 	if (acard->sb->hardware != SB_HW_16) {
 		snd_printk(KERN_ERR PFX "SB16 not found during probe\n");
-		return err;
+		return -ENODEV;
 	}
 
 	snd_wss_out(acard->wss, CS4231_MISC_INFO, 0x40); /* switch on MODE2 */
-- 
2.30.2



