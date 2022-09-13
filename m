Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F625B73E2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiIMPPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiIMPOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447146AA0A;
        Tue, 13 Sep 2022 07:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADF8A614E6;
        Tue, 13 Sep 2022 14:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19A8C433D6;
        Tue, 13 Sep 2022 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079489;
        bh=+XPBrIOIZ3AEbHVdiyGfUYR8D1RWCPPH5kCaPunTPDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vWE/v4rnkK0El4K3kRsc7EW8Jjx+pXFLh3DsiZlfQYYj/6CgThcRwpSsQbXtz2TO
         C+4KteKGfbVxpdrnIQVE5tCysCQjIN8gyl17XYLdS4hO7gLi9/nxsQ7xIUTSMrCGHI
         pWyUYoHJBXwu14RGJqOuB6Kpaj915O/dERhP8Jnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 47/79] ALSA: seq: oss: Fix data-race for max_midi_devs access
Date:   Tue, 13 Sep 2022 16:07:05 +0200
Message-Id: <20220913140351.181229954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
@@ -280,7 +280,9 @@ snd_seq_oss_midi_clear_all(void)
 void
 snd_seq_oss_midi_setup(struct seq_oss_devinfo *dp)
 {
+	spin_lock_irq(&register_lock);
 	dp->max_mididev = max_midi_devs;
+	spin_unlock_irq(&register_lock);
 }
 
 /*


