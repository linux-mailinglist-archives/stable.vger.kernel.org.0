Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F535404E5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbiFGRTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345785AbiFGRTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7381053F0;
        Tue,  7 Jun 2022 10:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37434B822B2;
        Tue,  7 Jun 2022 17:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B5C36B03;
        Tue,  7 Jun 2022 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622354;
        bh=u5A224ITF7Jbd92lBShOSFEqPcfNp0/n/3/NNPqjs1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ4PYiy7FKBwvBglogJ0to5XGvZgrbI2KpKfpupBFQ6Yhr/qK+FxePfRD/4aFYWGJ
         PHObj0WCvxFtvuQzPRluYy4KIN6XOOY7CqUHR5pF/deaIVv0zyID3T+fNG85WrVyXs
         VmIy7Ths7qQ/oViWAWSWCsdJXE64C4Nj0bxTprf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6912c9592caca7ca0e7d@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 008/452] ALSA: usb-audio: Cancel pending work at closing a MIDI substream
Date:   Tue,  7 Jun 2022 18:57:45 +0200
Message-Id: <20220607164908.782783180@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0125de38122f0f66bf61336158d12a1aabfe6425 upstream.

At closing a USB MIDI output substream, there might be still a pending
work, which would eventually access the rawmidi runtime object that is
being released.  For fixing the race, make sure to cancel the pending
work at closing.

Reported-by: syzbot+6912c9592caca7ca0e7d@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000e7e75005dfd07cf6@google.com
Link: https://lore.kernel.org/r/20220525131203.11299-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1161,6 +1161,9 @@ static int snd_usbmidi_output_open(struc
 
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
+	struct usbmidi_out_port *port = substream->runtime->private_data;
+
+	cancel_work_sync(&port->ep->work);
 	return substream_open(substream, 0, 0);
 }
 


