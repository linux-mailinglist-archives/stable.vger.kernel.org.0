Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8566C4F3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjAPQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjAPP7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:59:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97B234EA
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:59:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FFB061046
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC105C433EF;
        Mon, 16 Jan 2023 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884788;
        bh=0DOa9EAbWhG+o10onX0D6iLzZuuvud+JPATEwSwKjvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txQuTpd6TVE3VavpUlimmC0O/HDlfl0yByOSCRQgzSJv4EFcrWJ+xg/MAv54G8SPT
         3KtVXMrq+SxXmfkJYK+mjQbH2uE//5U4YcHp1u0+3aKfLh69ANikYlNEIdohil83B8
         M2mFiUz8dXHYte/XOEKujCSXi9rdFJ4QhjTTLgWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/183] ALSA: usb-audio: Make sure to stop endpoints before closing EPs
Date:   Mon, 16 Jan 2023 16:50:32 +0100
Message-Id: <20230116154807.976753184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0599313e26666e79f6e7fe1450588431b8cb25d5 ]

At the PCM hw params, we may re-configure the endpoints and it's done
by a temporary EP close followed by re-open.  A potential problem
there is that the EP might be already running internally at the PCM
prepare stage; it's seen typically in the playback stream with the
implicit feedback sync.  As this stream start isn't tracked by the
core PCM layer, we'd need to stop it explicitly, and that's the
missing piece.

This patch adds the stop_endpoints() call at snd_usb_hw_params() to
assure the stream stop before closing the EPs.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Link: https://lore.kernel.org/r/4e509aea-e563-e592-e652-ba44af6733fe@veniogames.com
Link: https://lore.kernel.org/r/20230102170759.29610-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index d2c652aa1385..535eb95bc9ee 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -527,6 +527,8 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		if (snd_usb_endpoint_compatible(chip, subs->data_endpoint,
 						fmt, hw_params))
 			goto unlock;
+		if (stop_endpoints(subs, false))
+			sync_pending_stops(subs);
 		close_endpoints(chip, subs);
 	}
 
-- 
2.35.1



