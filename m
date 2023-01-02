Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD165B115
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbjABLaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbjABL3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABC46445
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEFC360F21
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12216C433EF;
        Mon,  2 Jan 2023 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658948;
        bh=V8JDEOHxZYVaGl2463GBfoBZjYbsHwH465h8fIzUM6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhznYxnFfE7qc4Iw1qB8KbR27QN6R4qDfhe/M592YkC1WWuvDgg1Pd+YgT28gkIVC
         ixH34cQZFfN0GHxVyLszgB6pBNDvuHz77A6PcQynVPKIRVbx0qn/WPNuy3DSOmKTVM
         WQ/zH2yP8cXAJV12Z2cfFrrOA4BPTYYWOpXxPf64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artem Egorkine <arteme@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 60/74] ALSA: line6: fix stack overflow in line6_midi_transmit
Date:   Mon,  2 Jan 2023 12:22:33 +0100
Message-Id: <20230102110554.660113039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Artem Egorkine <arteme@gmail.com>

commit b8800d324abb50160560c636bfafe2c81001b66c upstream.

Correctly calculate available space including the size of the chunk
buffer. This fixes a buffer overflow when multiple MIDI sysex
messages are sent to a PODxt device.

Signed-off-by: Artem Egorkine <arteme@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221225105728.1153989-2-arteme@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/midi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -44,7 +44,8 @@ static void line6_midi_transmit(struct s
 	int req, done;
 
 	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		req = min3(line6_midibuf_bytes_free(mb), line6->max_packet_size,
+			   LINE6_FALLBACK_MAXPACKETSIZE);
 		done = snd_rawmidi_transmit_peek(substream, chunk, req);
 
 		if (done == 0)


