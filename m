Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E304725D3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhLMJqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbhLMJod (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:44:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFFDC061D5E;
        Mon, 13 Dec 2021 01:40:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9ED2B80E19;
        Mon, 13 Dec 2021 09:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CC1C00446;
        Mon, 13 Dec 2021 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388448;
        bh=+PfCJkbJZsskR/GCh/m+ZdAW7iA2MMayYcLX+c/hYpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhCFpXuwauT4z2IkF6617okCEKKevUN6sJNSS0O9KgcWp6+jiji1NTu65ATm7DwoB
         cf+34QFTT+/QQ7742RqIzAqtHKoiomigOrPhXlarPQLdJPIxelqZh39rzTGLhK4zQz
         HC0a0a28tAa8qX78/OUKGWxnXq9BHmLSqQdl70Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb348e9f9a954d42746f@syzkaller.appspotmail.com,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 26/74] ALSA: pcm: oss: Limit the period size to 16MB
Date:   Mon, 13 Dec 2021 10:29:57 +0100
Message-Id: <20211213092931.680864627@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -1967,7 +1967,7 @@ static int snd_pcm_oss_set_fragment1(str
 	if (runtime->oss.subdivision || runtime->oss.fragshift)
 		return -EINVAL;
 	fragshift = val & 0xffff;
-	if (fragshift >= 31)
+	if (fragshift >= 25) /* should be large enough */
 		return -EINVAL;
 	runtime->oss.fragshift = fragshift;
 	runtime->oss.maxfrags = (val >> 16) & 0xffff;


