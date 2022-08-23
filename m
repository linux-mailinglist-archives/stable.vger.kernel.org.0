Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC659D517
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346765AbiHWImh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345619AbiHWIkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148FB32ABB;
        Tue, 23 Aug 2022 01:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C60B81BF8;
        Tue, 23 Aug 2022 08:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6F2C433D6;
        Tue, 23 Aug 2022 08:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242719;
        bh=4dsBFVq/EY4Vczb4n0x3cAK3E7FUpiE5oSunj5mN74A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9PE/qoGqpmnrjviWhO6XPE9QpdxEDfuwrqtY7q1Y5djMHLqyu93sti8cIxP7ozH5
         PRpPV49jO6o8wdhrt6re6hkC/wr2iCyYB0EAP/fT44j7/YCaZkRc8k5sPyDbWUtlsH
         5mH4ibCi/CepkNEzi9spss/UDYVawjpsl8aolGc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Natalsson <harmoniesworlds@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 179/365] ASoC: DPCM: Dont pick up BE without substream
Date:   Tue, 23 Aug 2022 10:01:20 +0200
Message-Id: <20220823080125.709580979@linuxfoundation.org>
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

commit 754590651ccbbcc74a7c20907be4bb15d642bde3 upstream.

When DPCM tries to add valid BE connections at dpcm_add_paths(), it
doesn't check whether the picked BE actually supports for the given
stream direction.  Due to that, when an asymmetric BE stream is
present, it picks up wrongly and this may result in a NULL dereference
at a later point where the code assumes the existence of a
corresponding BE substream.

This patch adds the check for the presence of the substream for the
target BE for avoiding the problem above.

Note that we have already some fix for non-existing BE substream at
commit 6246f283d5e0 ("ASoC: dpcm: skip missing substream while
applying symmetry").  But the code path we've hit recently is rather
happening before the previous fix.  So this patch tries to fix at
picking up a BE instead of parsing BE lists.

Fixes: bbf7d3b1c4f4 ("ASoC: soc-pcm: align BE 'atomicity' with that of the FE")
Reported-by: Alex Natalsson <harmoniesworlds@gmail.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/CADs9LoPZH_D+eJ9qjTxSLE5jGyhKsjMN7g2NighZ16biVxsyKw@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220801170510.26582-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1318,6 +1318,9 @@ static struct snd_soc_pcm_runtime *dpcm_
 		if (!be->dai_link->no_pcm)
 			continue;
 
+		if (!snd_soc_dpcm_get_substream(be, stream))
+			continue;
+
 		for_each_rtd_dais(be, i, dai) {
 			w = snd_soc_dai_get_widget(dai, stream);
 


