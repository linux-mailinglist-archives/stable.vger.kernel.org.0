Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C64815C67B
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBMQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgBMPYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E923246A4;
        Thu, 13 Feb 2020 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607481;
        bh=CTsNSG9RAGIm5TNqWVpP5QVDKiL46+dVIx7R8/Sm4mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQ2G1NsFwWuQVkfjV5Kznhk8IEjdlJfFOs+ahaIwUR3Y95WmSLhSCxg7mIQ4tBnZ6
         /rl8urJhnsqeJEPEbpABuJyVqXl41+NLnk5TKuA5cPX0Gaq+XbsEE7yxVkCZpZj+kx
         z5Cq4sdbNQRvwJbEOXj1xd0uT/achXWW6HvBatTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 025/173] ALSA: dummy: Fix PCM format loop in proc output
Date:   Thu, 13 Feb 2020 07:18:48 -0800
Message-Id: <20200213151939.747279669@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2acf25f13ebe8beb40e97a1bbe76f36277c64f1e upstream.

The loop termination for iterating over all formats should contain
SNDRV_PCM_FORMAT_LAST, not less than it.

Fixes: 9b151fec139d ("ALSA: dummy - Add debug proc file")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200201080530.22390-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/drivers/dummy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -933,7 +933,7 @@ static void print_formats(struct snd_dum
 {
 	int i;
 
-	for (i = 0; i < SNDRV_PCM_FORMAT_LAST; i++) {
+	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
 		if (dummy->pcm_hw.formats & (1ULL << i))
 			snd_iprintf(buffer, " %s", snd_pcm_format_name(i));
 	}


