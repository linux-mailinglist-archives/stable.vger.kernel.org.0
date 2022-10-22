Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6476085A6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJVHgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJVHg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:36:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FF036DD5;
        Sat, 22 Oct 2022 00:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A123B82DEF;
        Sat, 22 Oct 2022 07:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65988C433D6;
        Sat, 22 Oct 2022 07:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424107;
        bh=8fi4KRnTeAjrn2RZpFpUaMqKpGr4C7VXsqZt/H77q6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyenJxijD2Whif/fKhAg65xur7rVaqr9O8y6TOVV4gtMCw9u++ckorYghGGbf8OH4
         V87bU5MbMfhMHLHlP+JVTSm2pybgcjkM2WNi18WFyngwp/bFJKHEOGPtxulZ1LqU7B
         FHutiANflQ2GMW0s2azv3lwdoFPIVbt+iPca243s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 003/717] ALSA: rawmidi: Drop register_mutex in snd_rawmidi_free()
Date:   Sat, 22 Oct 2022 09:18:02 +0200
Message-Id: <20221022072415.630907767@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit a70aef7982b012e86dfd39fbb235e76a21ae778a upstream.

The register_mutex taken around the dev_unregister callback call in
snd_rawmidi_free() may potentially lead to a mutex deadlock, when OSS
emulation and a hot unplug are involved.

Since the mutex doesn't protect the actual race (as the registration
itself is already protected by another means), let's drop it.

Link: https://lore.kernel.org/r/CAB7eexJP7w1B0mVgDF0dQ+gWor7UdkiwPczmL7pn91xx8xpzOA@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221011070147.7611-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1835,10 +1835,8 @@ static int snd_rawmidi_free(struct snd_r
 
 	snd_info_free_entry(rmidi->proc_entry);
 	rmidi->proc_entry = NULL;
-	mutex_lock(&register_mutex);
 	if (rmidi->ops && rmidi->ops->dev_unregister)
 		rmidi->ops->dev_unregister(rmidi);
-	mutex_unlock(&register_mutex);
 
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_INPUT]);
 	snd_rawmidi_free_substreams(&rmidi->streams[SNDRV_RAWMIDI_STREAM_OUTPUT]);


