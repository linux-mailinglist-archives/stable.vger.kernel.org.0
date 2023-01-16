Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FC66C4D2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjAPP6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbjAPP6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B23CA5F5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E66DB8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFC2C433D2;
        Mon, 16 Jan 2023 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884709;
        bh=zsq3p6s+XnOIxGRfuCJrHApRakwMCUBzCs3MTRyB6pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGXzQZ0eyoGDHF4YwQcOXmUT9XWv+HEoXWVc357smXGh7up4jhS6VjFZkkP3Qm0Nx
         ENx5Lt4Xr7A+XHJRJfEhA6ksi48Tvgq3W4Y92jglEyKb0mOEW3uHVDxWpiVZpdlKfo
         bVsjgkrYq+G5TaeU//mxaK7rSeP2j2nqzIIcgvoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ruud van Asseldonk <ruud@veniogames.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/183] ALSA: usb-audio: Relax hw constraints for implicit fb sync
Date:   Mon, 16 Jan 2023 16:50:33 +0100
Message-Id: <20230116154808.016540940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d463ac1acb454fafed58f695cb3067fbf489f3a0 ]

The fix commit the commit e4ea77f8e53f ("ALSA: usb-audio: Always apply
the hw constraints for implicit fb sync") tried to address the bug
where an incorrect PCM parameter is chosen when two (implicit fb)
streams are set up at the same time.  This change had, however, some
side effect: once when the sync endpoint is chosen and set up, this
restriction is applied at the next hw params unless it's freed via hw
free explicitly.

This patch is a workaround for the problem by relaxing the hw
constraints a bit for the implicit fb sync.  We still keep applying
the hw constraints for implicit fb sync, but only when the matching
sync EP is being used by other streams.

Fixes: e4ea77f8e53f ("ALSA: usb-audio: Always apply the hw constraints for implicit fb sync")
Reported-by: Ruud van Asseldonk <ruud@veniogames.com>
Link: https://lore.kernel.org/r/4e509aea-e563-e592-e652-ba44af6733fe@veniogames.com
Link: https://lore.kernel.org/r/20230102170759.29610-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 535eb95bc9ee..29838000eee0 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -939,8 +939,13 @@ get_sync_ep_from_substream(struct snd_usb_substream *subs)
 			continue;
 		/* for the implicit fb, check the sync ep as well */
 		ep = snd_usb_get_endpoint(chip, fp->sync_ep);
-		if (ep && ep->cur_audiofmt)
-			return ep;
+		if (ep && ep->cur_audiofmt) {
+			/* ditto, if the sync (data) ep is used by others,
+			 * this stream is restricted by the sync ep
+			 */
+			if (ep != subs->sync_endpoint || ep->opened > 1)
+				return ep;
+		}
 	}
 	return NULL;
 }
-- 
2.35.1



