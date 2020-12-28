Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508342E4324
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbgL1Pds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407405AbgL1NyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D622C20738;
        Mon, 28 Dec 2020 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163609;
        bh=r24g29K/F1pGRKDRsBgJJuEEfKWtMmPrNKuHGtX5zjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB3LC1qLhnH/yzktjsrpWAyvSR1aB8JBVEPOuaKHEUAJJ6yvKngzrEa2vUlJ3QkA4
         KVMVDsSvB0wXg/D9tt6kHYX93WW/7wfSSGB46XsWnte1SnPk2U5PZnTVDXkL3Iziyb
         RRQDC+0xmxuNlEE0P2vdziXbZxdHaH8L1hcgzeB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Gong <yibin.gong@nxp.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 346/453] ALSA: core: memalloc: add page alignment for iram
Date:   Mon, 28 Dec 2020 13:49:42 +0100
Message-Id: <20201228124953.871962440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -76,7 +76,8 @@ static void snd_malloc_dev_iram(struct s
 	/* Assign the pool into private_data field */
 	dmab->private_data = pool;
 
-	dmab->area = gen_pool_dma_alloc(pool, size, &dmab->addr);
+	dmab->area = gen_pool_dma_alloc_align(pool, size, &dmab->addr,
+					PAGE_SIZE);
 }
 
 /**


