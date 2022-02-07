Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08904ABD82
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377781AbiBGLoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385234AbiBGLb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8297C02B750;
        Mon,  7 Feb 2022 03:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 768E960A67;
        Mon,  7 Feb 2022 11:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3809CC004E1;
        Mon,  7 Feb 2022 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233385;
        bh=OtP5r+gyCFy9t1qM39CdxkthGbobIllUleGvZdo9M9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZ5F2WKF/P2sC563mjfEDcQa/whNZgOR+dvNvmGELRP1vEKFJHrTzU4BYLRRuIqQU
         YSL3aPDCQX5Dvycw+fzkIlMYfeXbOTRF/CqCExyv9xgW242CScEuHIP/8eQ0/56XI9
         UHWD7nbbJ4K33Lm2ztNzuhMe1LUJZfKImAtds0o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 106/110] tools include UAPI: Sync sound/asound.h copy with the kernel sources
Date:   Mon,  7 Feb 2022 12:07:19 +0100
Message-Id: <20220207103805.980470477@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 4f2492731ada9d702ffdfaa6ec1ff64820a1664c upstream.

Picking the changes from:

  06feec6005c9d950 ("ASoC: hdmi-codec: Fix OOB memory accesses")

Which entails no changes in the tooling side as it doesn't introduce new
SNDRV_PCM_IOCTL_ ioctls.

To silence this perf tools build warning:

  Warning: Kernel ABI header at 'tools/include/uapi/sound/asound.h' differs from latest version at 'include/uapi/sound/asound.h'
  diff -u tools/include/uapi/sound/asound.h include/uapi/sound/asound.h

Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/lkml/Yf+6OT+2eMrYDEeX@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/sound/asound.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/include/uapi/sound/asound.h
+++ b/tools/include/uapi/sound/asound.h
@@ -56,8 +56,10 @@
  *                                                                          *
  ****************************************************************************/
 
+#define AES_IEC958_STATUS_SIZE		24
+
 struct snd_aes_iec958 {
-	unsigned char status[24];	/* AES/IEC958 channel status bits */
+	unsigned char status[AES_IEC958_STATUS_SIZE]; /* AES/IEC958 channel status bits */
 	unsigned char subcode[147];	/* AES/IEC958 subcode bits */
 	unsigned char pad;		/* nothing */
 	unsigned char dig_subframe[4];	/* AES/IEC958 subframe bits */


