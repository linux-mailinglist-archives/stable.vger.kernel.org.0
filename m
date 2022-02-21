Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436604BE03F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351110AbiBUJvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:51:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351632AbiBUJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:49:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5AB34B8B;
        Mon, 21 Feb 2022 01:22:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C915160F3C;
        Mon, 21 Feb 2022 09:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC204C340EB;
        Mon, 21 Feb 2022 09:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435357;
        bh=4/IQDapPhOfUHZ8I/bXCAqRqXgprEmYdeOsY8JUFMrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nemIO3vDO6nbq3rN5HagG0zNwCMK9Cd3sJrcTn4GppDJ6DqNwHBaFySmBU6Swi9rF
         oi81m0RG2L5gHQ9ZMX39Kid+cjVW1AVYIV8/tSv76ruorQ9/ZGIumh6qrxjy/sW72W
         xmy0fQaazfpRW5XQxYbNbSCHkSz3fHQCQ5lhJU94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 135/227] ALSA: usb-audio: Dont abort resume upon errors
Date:   Mon, 21 Feb 2022 09:49:14 +0100
Message-Id: <20220221084939.341918784@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9a5adeb28b77416446658e75bdef3bbe5fb92a83 upstream.

The default mixer resume code treats the errors at restoring the
modified mixer items as a fatal error, and it returns back to the
caller.  This ends up in the resume failure, and the device will be
come unavailable, although basically those errors are intermittent and
can be safely ignored.

The problem itself has been present from the beginning, but it didn't
hit usually because the code tries to resume only the modified items.
But now with the recent commit to forcibly initialize each item at the
probe time, the problem surfaced more often, hence it appears as a
regression.

This patch fixes the regression simply by ignoring the errors at
resume.

Fixes: b96681bd5827 ("ALSA: usb-audio: Initialize every feature unit once at probe time")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215561
Link: https://lore.kernel.org/r/20220214125711.20531-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3678,17 +3678,14 @@ static int restore_mixer_value(struct us
 				err = snd_usb_set_cur_mix_value(cval, c + 1, idx,
 							cval->cache_val[idx]);
 				if (err < 0)
-					return err;
+					break;
 			}
 			idx++;
 		}
 	} else {
 		/* master */
-		if (cval->cached) {
-			err = snd_usb_set_cur_mix_value(cval, 0, 0, *cval->cache_val);
-			if (err < 0)
-				return err;
-		}
+		if (cval->cached)
+			snd_usb_set_cur_mix_value(cval, 0, 0, *cval->cache_val);
 	}
 
 	return 0;


