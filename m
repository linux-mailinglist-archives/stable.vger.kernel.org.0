Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CC45B72A8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiIMO7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiIMO7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C93973929;
        Tue, 13 Sep 2022 07:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7055614B7;
        Tue, 13 Sep 2022 14:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7689C433D6;
        Tue, 13 Sep 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079313;
        bh=euG67sgDvwLXIEgTY2TWW6s7v4hP9aP7Kb+DIRT65rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNWQm4AJpgHBEZ0J10OIL0BnM0tbP176PJGebW+Yo0XhMcAuGSBhQ/vfLvmm4Y6yy
         5iCdJbPqT3fJ1XcCieRq6KNcitxvBIasL/CZQJG5p07x7BLHDlN7NQa5tT0Am8+y6A
         pNicHqYVX28szuxao5a6Edp6eCA29Mw9OfA6qmMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 059/108] ALSA: seq: oss: Fix data-race for max_midi_devs access
Date:   Tue, 13 Sep 2022 16:06:30 +0200
Message-Id: <20220913140356.160725210@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 22dec134dbfa825b963f8a1807ad19b943e46a56 upstream.

ALSA OSS sequencer refers to a global variable max_midi_devs at
creating a new port, storing it to its own field.  Meanwhile this
variable may be changed by other sequencer events at
snd_seq_oss_midi_check_exit_port() in parallel, which may cause a data
race.

OTOH, this data race itself is almost harmless, as the access to the
MIDI device is done via get_mdev() and it's protected with a refcount,
hence its presence is guaranteed.

Though, it's sill better to address the data-race from the code sanity
POV, and this patch adds the proper spinlock for the protection.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAEHB2493pZRXs863w58QWnUTtv3HHfg85aYhLn5HJHCwxqtHQg@mail.gmail.com
Link: https://lore.kernel.org/r/20220823072717.1706-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/oss/seq_oss_midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -267,7 +267,9 @@ snd_seq_oss_midi_clear_all(void)
 void
 snd_seq_oss_midi_setup(struct seq_oss_devinfo *dp)
 {
+	spin_lock_irq(&register_lock);
 	dp->max_mididev = max_midi_devs;
+	spin_unlock_irq(&register_lock);
 }
 
 /*


