Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0444725B2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhLMJpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:45:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36804 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbhLMJnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:43:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8FCECE0E6F;
        Mon, 13 Dec 2021 09:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B4FC341CA;
        Mon, 13 Dec 2021 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388596;
        bh=rinA5Oho5YlhS85gOrLe4tXmrUm1hPkE6VJnbLkHfXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXUDuPR22YAKd4QRIXhbs+QpAL5IJOKX0noLQ9BEfax2lE92zuYCmvTk6QoL4m0vg
         aqPPfUMR29MMlEKqu0I+JVyayx0DVCXZQyKWL4ydJlehXYU5yHYc9LkKcSWPe2FgnN
         PFphlIXrJ/VlP0uRoiYFhph1oh7N/ZwIp0XJERHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb348e9f9a954d42746f@syzkaller.appspotmail.com,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 31/88] ALSA: pcm: oss: Limit the period size to 16MB
Date:   Mon, 13 Dec 2021 10:30:01 +0100
Message-Id: <20211213092934.298941420@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8839c8c0f77ab8fc0463f4ab8b37fca3f70677c2 upstream.

Set the practical limit to the period size (the fragment shift in OSS)
instead of a full 31bit; a too large value could lead to the exhaust
of memory as we allocate temporary buffers of the period size, too.

As of this patch, we set to 16MB limit, which should cover all use
cases.

Reported-by: syzbot+bb348e9f9a954d42746f@syzkaller.appspotmail.com
Reported-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1638270978-42412-1-git-send-email-cuibixuan@linux.alibaba.com
Link: https://lore.kernel.org/r/20211201073606.11660-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/pcm_oss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1952,7 +1952,7 @@ static int snd_pcm_oss_set_fragment1(str
 	if (runtime->oss.subdivision || runtime->oss.fragshift)
 		return -EINVAL;
 	fragshift = val & 0xffff;
-	if (fragshift >= 31)
+	if (fragshift >= 25) /* should be large enough */
 		return -EINVAL;
 	runtime->oss.fragshift = fragshift;
 	runtime->oss.maxfrags = (val >> 16) & 0xffff;


