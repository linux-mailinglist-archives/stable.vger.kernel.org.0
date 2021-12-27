Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2571A47FE57
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbhL0P2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbhL0P2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E0DC06175D;
        Mon, 27 Dec 2021 07:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90E3CB810A2;
        Mon, 27 Dec 2021 15:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D902BC36AE7;
        Mon, 27 Dec 2021 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618886;
        bh=eyAmaDD1JXqATBeZS1M1Z9XqejQePk2SYXuoUol7srg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph5n+I7abPBL2SKHMOTsAdRdCvxAKFy3S0/hLJyh4V7yfWGjUAFLQfbXMs9FAzhWN
         HScS4+tbA6g4b3NvotL+q2onJ+k1wEHXoSx6h3nBsRi958WRreoYOT0kcC7/veqHKS
         LDONrO997tNGTrkqb2mEtJWQ2F9Iml6NR+3XiPfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 09/17] ALSA: jack: Check the return value of kstrdup()
Date:   Mon, 27 Dec 2021 16:27:04 +0100
Message-Id: <20211227151316.260151757@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
References: <20211227151315.962187770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

commit c01c1db1dc632edafb0dff32d40daf4f9c1a4e19 upstream.

kstrdup() can return NULL, it is better to check the return value of it.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/tencent_094816F3522E0DC704056C789352EBBF0606@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/jack.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -227,6 +227,10 @@ int snd_jack_new(struct snd_card *card,
 		return -ENOMEM;
 
 	jack->id = kstrdup(id, GFP_KERNEL);
+	if (jack->id == NULL) {
+		kfree(jack);
+		return -ENOMEM;
+	}
 
 	/* don't creat input device for phantom jack */
 	if (!phantom_jack) {


