Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECA16E6471
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjDRMtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjDRMtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB391563D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE2D6633F4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3951C433D2;
        Tue, 18 Apr 2023 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822143;
        bh=+u1662A/TS/jEK57TZTkhaiBLkAVM7lwAXCYbZamQng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drni8X0E3Dfuk0aK38Rcz6AovZHWHLK6RsMa5oNRDxg3kQrZlo+ypSVr+Cx8Y9AaL
         +wiUZNnSRRzo+HLdeQv439Sw3sVbZFQDEGa+j0lUg5TTPLgChefPQuG8OcqwaI/4+R
         AcWVJksd3jNG2UDHjBod6b3spCiAgpiXH8wPnvTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Biang <xubiang@hust.edu.cn>,
        Dan Carpenter <error27@gmail.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 009/139] ALSA: firewire-tascam: add missing unwind goto in snd_tscm_stream_start_duplex()
Date:   Tue, 18 Apr 2023 14:21:14 +0200
Message-Id: <20230418120314.058253037@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Biang <xubiang@hust.edu.cn>

commit fb4a624f88f658c7b7ae124452bd42eaa8ac7168 upstream.

Smatch Warns:
sound/firewire/tascam/tascam-stream.c:493 snd_tscm_stream_start_duplex()
warn: missing unwind goto?

The direct return will cause the stream list of "&tscm->domain" unemptied
and the session in "tscm" unfinished if amdtp_domain_start() returns with
an error.

Fix this by changing the direct return to a goto which will empty the
stream list of "&tscm->domain" and finish the session in "tscm".

The snd_tscm_stream_start_duplex() function is called in the prepare
callback of PCM. According to "ALSA Kernel API Documentation", the prepare
callback of PCM will be called many times at each setup. So, if the
"&d->streams" list is not emptied, when the prepare callback is called
next time, snd_tscm_stream_start_duplex() will receive -EBUSY from
amdtp_domain_add_stream() that tries to add an existing stream to the
domain. The error handling code after the "error" label will be executed
in this case, and the "&d->streams" list will be emptied. So not emptying
the "&d->streams" list will not cause an issue. But it is more efficient
and readable to empty it on the first error by changing the direct return
to a goto statement.

The session in "tscm" has been begun before amdtp_domain_start(), so it
needs to be finished when amdtp_domain_start() fails.

Fixes: c281d46a51e3 ("ALSA: firewire-tascam: support AMDTP domain")
Signed-off-by: Xu Biang <xubiang@hust.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230406132801.105108-1-xubiang@hust.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/tascam/tascam-stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -490,7 +490,7 @@ int snd_tscm_stream_start_duplex(struct
 		// packet is important for media clock recovery.
 		err = amdtp_domain_start(&tscm->domain, tx_init_skip_cycles, true, true);
 		if (err < 0)
-			return err;
+			goto error;
 
 		if (!amdtp_domain_wait_ready(&tscm->domain, READY_TIMEOUT_MS)) {
 			err = -ETIMEDOUT;


