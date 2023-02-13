Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050C969494F
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBMO6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjBMO6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B33E1CF7F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0177A6115B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A982C433EF;
        Mon, 13 Feb 2023 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300256;
        bh=B13805gmhGPOmN6wVSEdk+PBO4qrsLdTpxK+F9q3AEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0pVdkDdSZ+abcJmwG0kgS0z+nMtySEeQ9rW0MU/dvObG65HmgkYg+g0KAMlVwSzu
         YAdwUeWCg7rpTDH/yPLs11aBuHjo/77sG1lo4xKSwLUt5eZFBaR25xbDEwGslj5A51
         zRevzKeg/jDhKI85jBwU/j5EkLyIBRM7RHxLC77Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artemii Karasev <karasev@ispras.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 09/67] ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()
Date:   Mon, 13 Feb 2023 15:48:50 +0100
Message-Id: <20230213144732.760980362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artemii Karasev <karasev@ispras.ru>

commit 6a32425f953b955b4ff82f339d01df0b713caa5d upstream.

snd_emux_xg_control() can be called with an argument 'param' greater
than size of 'control' array. It may lead to accessing 'control'
array at a wrong index.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Artemii Karasev <karasev@ispras.ru>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230207132026.2870-1-karasev@ispras.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux_nrpn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/synth/emux/emux_nrpn.c
+++ b/sound/synth/emux/emux_nrpn.c
@@ -349,6 +349,9 @@ int
 snd_emux_xg_control(struct snd_emux_port *port, struct snd_midi_channel *chan,
 		    int param)
 {
+	if (param >= ARRAY_SIZE(chan->control))
+		return -EINVAL;
+
 	return send_converted_effect(xg_effects, ARRAY_SIZE(xg_effects),
 				     port, chan, param,
 				     chan->control[param],


