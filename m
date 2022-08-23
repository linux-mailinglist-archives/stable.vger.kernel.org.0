Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231BA59D4ED
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345227AbiHWIkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344741AbiHWIjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:39:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3999B1401D;
        Tue, 23 Aug 2022 01:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E830B81C4B;
        Tue, 23 Aug 2022 08:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9717AC433D6;
        Tue, 23 Aug 2022 08:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242710;
        bh=Ifo1c328SdBt/vUETtDn0Qt+M/Wj0wNycavFs6K4Gsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ6WmJ9mb5UBfWG52VubvB8BUJa1mWYplOre6htbpzUj5LomEnexdazW5q9pBrpgx
         svuDw3H9E32aahlcRroL/0SSOIUlW3QQYyi0AuLG4wh2hFbgyQPvbcxMc0tFisqJfl
         20AF0MN1c70USZE+ZCKR4VhA9PcoFyasv7V5GVQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 176/365] ASoC: Intel: avs: Fix potential buffer overflow by snprintf()
Date:   Tue, 23 Aug 2022 10:01:17 +0200
Message-Id: <20220823080125.576859163@linuxfoundation.org>
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

commit ca3b7b9dc9bc1fa552f4697b7cccfa0258a44d00 upstream.

snprintf() returns the would-be-filled size when the string overflows
the given buffer size, hence using this value may result in a buffer
overflow (although it's unrealistic).

This patch replaces it with a safer version, scnprintf() for papering
over such a potential issue.

Fixes: f1b3b320bd65 ("ASoC: Intel: avs: Generic soc component driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220801165420.25978-2-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/avs/pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -636,8 +636,8 @@ static ssize_t topology_name_read(struct
 	char buf[64];
 	size_t len;
 
-	len = snprintf(buf, sizeof(buf), "%s/%s\n", component->driver->topology_name_prefix,
-		       mach->tplg_filename);
+	len = scnprintf(buf, sizeof(buf), "%s/%s\n", component->driver->topology_name_prefix,
+			mach->tplg_filename);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }


