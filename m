Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1202553CF89
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiFCRyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347270AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B8113D16;
        Fri,  3 Jun 2022 10:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67851B82419;
        Fri,  3 Jun 2022 17:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB3CC385A9;
        Fri,  3 Jun 2022 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278713;
        bh=xF4TwzXvI/vuD2ZvHNLqd2yjZu07Y0fkHy+dpnoz9IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkDp1dJcD5SSNhf+DLlVz8jsBdsVQMLkBxRErVY6TFjTiR2xOZW0zG6al8MXiuo4J
         WDdy5VGovXDMNSVVH+M0H5N86BWkTlfSMoAXrwuc1pTguTKKpCkFepVzPcqsycE/sl
         0ndQq5z8VKpMrN+kTtE6bP6Gb1fVZpToOOiBhoH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Craig McLure <craig@mclure.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 39/66] ALSA: usb-audio: Configure sync endpoints before data
Date:   Fri,  3 Jun 2022 19:43:19 +0200
Message-Id: <20220603173821.802500760@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Craig McLure <craig@mclure.net>

commit 0e85a22d01dfe9ad9a9d9e87cd4a88acce1aad65 upstream.

Devices such as the TC-Helicon GoXLR require the sync endpoint to be
configured in advance of the data endpoint in order for sound output
to work.

This patch simply changes the ordering of EP configuration to resolve
this.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215079
Signed-off-by: Craig McLure <craig@mclure.net>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220524062115.25968-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 6d699065e81a..b470404a5376 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -439,16 +439,21 @@ static int configure_endpoints(struct snd_usb_audio *chip,
 		/* stop any running stream beforehand */
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
+		if (subs->sync_endpoint) {
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			if (err < 0)
+				return err;
+		}
 		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
-	}
-
-	if (subs->sync_endpoint) {
-		err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
-		if (err < 0)
-			return err;
+	} else {
+		if (subs->sync_endpoint) {
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	return 0;
-- 
2.36.1



