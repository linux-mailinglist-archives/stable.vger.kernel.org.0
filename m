Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E53E157C4A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgBJNg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbgBJMfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:12 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16A8208C3;
        Mon, 10 Feb 2020 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338111;
        bh=9Ri+i5cX/V998kOhcG7bZRrMYPjofvjRpnHqyc9ArmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOkdPgQ3WBmJA/3l1y7q1gti4PyickiEp8f7nYeeRwFQHTz7kX4encQqudL4W8HZz
         BfNZG2NJOF5S9xzpNLgljHsQq7CMvxxQwwI9hzjZ+TTdmDquksQqx5BNtAkm9qBWEx
         JrEKaZaaP4Kfr/yhJujTlDwriUZjvpPp7HxP+5rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 037/195] ALSA: dummy: Fix PCM format loop in proc output
Date:   Mon, 10 Feb 2020 04:31:35 -0800
Message-Id: <20200210122310.118526242@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -929,7 +929,7 @@ static void print_formats(struct snd_dum
 {
 	int i;
 
-	for (i = 0; i < SNDRV_PCM_FORMAT_LAST; i++) {
+	for (i = 0; i <= SNDRV_PCM_FORMAT_LAST; i++) {
 		if (dummy->pcm_hw.formats & (1ULL << i))
 			snd_iprintf(buffer, " %s", snd_pcm_format_name(i));
 	}


