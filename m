Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694132E3FB1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506365AbgL1OnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503923AbgL1O05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A5720715;
        Mon, 28 Dec 2020 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165577;
        bh=nBYK6x9kWnsIhtwZ0HyQfAepw952HoVPfPhFSHKERfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+6eFEshz6DyWIiEKJc5G5nfNEzcoyPy0vMmBO5eoBGetQEZho4CHzsEsoL7sZF+J
         hYs50TEgyHPSsbYoXKnrGV67agQjxijy+XBs6KH+kAVkhYVh0LTGMdORCz9gcrARm+
         Vs4ro1vcA7U02bqaypwirLeuvaj857iFSgbNAKfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 550/717] ALSA: core: memalloc: add page alignment for iram
Date:   Mon, 28 Dec 2020 13:49:08 +0100
Message-Id: <20201228125047.284493116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gong <yibin.gong@nxp.com>

commit 74c64efa1557fef731b59eb813f115436d18078e upstream.

Since mmap for userspace is based on page alignment, add page alignment
for iram alloc from pool, otherwise, some good data located in the same
page of dmab->area maybe touched wrongly by userspace like pulseaudio.

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1608221747-3474-1-git-send-email-yibin.gong@nxp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/memalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -77,7 +77,8 @@ static void snd_malloc_dev_iram(struct s
 	/* Assign the pool into private_data field */
 	dmab->private_data = pool;
 
-	dmab->area = gen_pool_dma_alloc(pool, size, &dmab->addr);
+	dmab->area = gen_pool_dma_alloc_align(pool, size, &dmab->addr,
+					PAGE_SIZE);
 }
 
 /**


