Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88C53CFE6
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345918AbiFCR6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345955AbiFCR5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:57:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54EC57103;
        Fri,  3 Jun 2022 10:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77761B82419;
        Fri,  3 Jun 2022 17:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A82C385A9;
        Fri,  3 Jun 2022 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278847;
        bh=rsXX6yLeIHVO6O+swiWLs088Z3L8fZkQ83Rdgo4SA0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qpbum80npmMJ6T8JYQGk2+futFlhPZ+Ap25l401H8Q33yuD5oGzBBBGpxnMLYrwwg
         nkCW5jJapioUhGSrycAQXLwzFRdDRCU3izOpPp6Y6MfkqKjML/vERzi6cI9jVOHV8g
         rEzWkG9MZ3tt/bsj6JGCVfLSbUeL4Fyvi0bS4+Sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Craig McLure <craig@mclure.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 46/75] ALSA: usb-audio: Configure sync endpoints before data
Date:   Fri,  3 Jun 2022 19:43:30 +0200
Message-Id: <20220603173823.053919630@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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
 sound/usb/pcm.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -439,16 +439,21 @@ static int configure_endpoints(struct sn
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


