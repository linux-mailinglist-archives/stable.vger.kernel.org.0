Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570D0531CD4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbiEWRdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241562AbiEWRaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6234C405;
        Mon, 23 May 2022 10:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BEB60916;
        Mon, 23 May 2022 17:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0189C385A9;
        Mon, 23 May 2022 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326748;
        bh=GBc26s17BmQw9HacxvTdrlw6HMMuVI1jH1R6N3f3C/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prlwEDAGCQtTtE9x50vS9oauUMA7z5rArJyvc5vZsscBLvCiqCDEluN2ksTueRMiA
         uNobb7CKo3Z2vyJPA4DVGSQ+MR+q7cYxo1FfN+tkA8pJ51yWEXIsBFFHOZfCotrJDA
         bUB/uvZxo0oT5N7saLUGZRlUT3xcJX5w7Neda2c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 047/158] ALSA: wavefront: Proper check of get_user() error
Date:   Mon, 23 May 2022 19:03:24 +0200
Message-Id: <20220523165838.439180604@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a34ae6c0660d3b96b0055f68ef74dc9478852245 upstream.

The antient ISA wavefront driver reads its sample patch data (uploaded
over an ioctl) via __get_user() with no good reason; likely just for
some performance optimizations in the past.  Let's change this to the
standard get_user() and the error check for handling the fault case
properly.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220510103626.16635-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_synth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1094,7 +1094,8 @@ wavefront_send_sample (snd_wavefront_t *
 
 			if (dataptr < data_end) {
 		
-				__get_user (sample_short, dataptr);
+				if (get_user(sample_short, dataptr))
+					return -EFAULT;
 				dataptr += skip;
 		
 				if (data_is_unsigned) { /* GUS ? */


