Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F2B59D5A4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiHWIma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348619AbiHWIln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:41:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EF67A76F;
        Tue, 23 Aug 2022 01:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F6A861388;
        Tue, 23 Aug 2022 08:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC0C433D6;
        Tue, 23 Aug 2022 08:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242713;
        bh=P2NEBc2H85qsMBFTU4JMsHFgSL2p2zn/OeqE9orNI9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAEnkw2UqIFg4BI044cT0DN1y36YCvyNR0/4FnhwC14sH4I3ozT2BQWZRNYTw62SY
         C8Q6+aO5npw5id+X3uqtdZzWcRt3vumZmPLta4ITOwHpBpZ0GAQYYeyAvM9obdtcIH
         bWOwFtQS2fHBARRgFiAe6HglWauZKaDFpnm7RZWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 177/365] ASoC: SOF: debug: Fix potential buffer overflow by snprintf()
Date:   Tue, 23 Aug 2022 10:01:18 +0200
Message-Id: <20220823080125.626228574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

commit 1eb123ce985e6cf302ac6e3f19862d132d86fa8f upstream.

snprintf() returns the would-be-filled size when the string overflows
the given buffer size, hence using this value may result in the buffer
overflow (although it's unrealistic).

This patch replaces with a safer version, scnprintf() for papering
over such a potential issue.

Fixes: 5b10b6298921 ("ASoC: SOF: Add `memory_info` file to debugfs")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220801165420.25978-3-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -252,9 +252,9 @@ static int memory_info_update(struct snd
 	}
 
 	for (i = 0, len = 0; i < reply->num_elems; i++) {
-		ret = snprintf(buf + len, buff_size - len, "zone %d.%d used %#8x free %#8x\n",
-			       reply->elems[i].zone, reply->elems[i].id,
-			       reply->elems[i].used, reply->elems[i].free);
+		ret = scnprintf(buf + len, buff_size - len, "zone %d.%d used %#8x free %#8x\n",
+				reply->elems[i].zone, reply->elems[i].id,
+				reply->elems[i].used, reply->elems[i].free);
 		if (ret < 0)
 			goto error;
 		len += ret;


