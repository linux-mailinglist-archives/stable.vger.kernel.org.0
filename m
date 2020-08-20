Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4A124BE4C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730726AbgHTNXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbgHTJeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1396D22BEA;
        Thu, 20 Aug 2020 09:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916016;
        bh=+2rkOLTAojPpciCsfnRQKWhqYJpIMKTSKUdmYJd/ZrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdgrSbV39mPTGSZiObH+wrl1v++OXQsTVXt7zvZNjFIz560lIIA7jDRSSOPA8vSx0
         eN8+xidLKNkQ4GEoFXbEe5Ci/efsd83ImqDXjQ0P4D56mKD361RCe2/aMlEYdmgM5J
         z+cNKe8JlKDrdbNFEdsXhLYEpfDR9wzDp7pQ3uHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 214/232] ALSA: echoaudio: Fix potential Oops in snd_echo_resume()
Date:   Thu, 20 Aug 2020 11:21:05 +0200
Message-Id: <20200820091623.161937546@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5a25de6df789cc805a9b8ba7ab5deef5067af47e ]

Freeing chip on error may lead to an Oops at the next time
the system goes to resume. Fix this by removing all
snd_echo_free() calls on error.

Fixes: 47b5d028fdce8 ("ALSA: Echoaudio - Add suspend support #2")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20200813074632.17022-1-dinghao.liu@zju.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/echoaudio/echoaudio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 0941a7a17623a..456219a665a79 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -2158,7 +2158,6 @@ static int snd_echo_resume(struct device *dev)
 	if (err < 0) {
 		kfree(commpage_bak);
 		dev_err(dev, "resume init_hw err=%d\n", err);
-		snd_echo_free(chip);
 		return err;
 	}
 
@@ -2185,7 +2184,6 @@ static int snd_echo_resume(struct device *dev)
 	if (request_irq(pci->irq, snd_echo_interrupt, IRQF_SHARED,
 			KBUILD_MODNAME, chip)) {
 		dev_err(chip->card->dev, "cannot grab irq\n");
-		snd_echo_free(chip);
 		return -EBUSY;
 	}
 	chip->irq = pci->irq;
-- 
2.25.1



