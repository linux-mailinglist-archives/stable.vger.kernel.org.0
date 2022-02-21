Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7679A4BE8CC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbiBUJea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:34:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350598AbiBUJds (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:33:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7153029808;
        Mon, 21 Feb 2022 01:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C7A3CE0E79;
        Mon, 21 Feb 2022 09:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3DBC36AF5;
        Mon, 21 Feb 2022 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434845;
        bh=ihAIbfYlvinEEfGKUNpuvcQtGz1ie3/Qc9/kth+Vujs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6AV1avi7wuvwwX/DGj1W9GsEIG0105d5G18oFvCKAYypN6wV9VmbwPzvcfQSOEc0
         1VbAqdp/uQeUd/259D7r3HAIiYxBRBJShSZp1B+Ttjnw+PCSlGjwu4cQ3CL2Fw9Dku
         3DHjoZc/o/K4u9l6zqTRSAYgVt8oTpJ2fsluWciU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 119/196] ASoC: ops: Fix stereo change notifications in snd_soc_put_xr_sx()
Date:   Mon, 21 Feb 2022 09:49:11 +0100
Message-Id: <20220221084934.918122027@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 2b7c46369f09c358164d31d17e5695185403185e upstream.

When writing out a stereo control we discard the change notification from
the first channel, meaning that events are only generated based on changes
to the second channel. Ensure that we report a change if either channel
has changed.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220201155629.120510-5-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -895,6 +895,7 @@ int snd_soc_put_xr_sx(struct snd_kcontro
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;
 	long val = ucontrol->value.integer.value[0];
+	int ret = 0;
 	unsigned int i;
 
 	if (val < mc->min || val > mc->max)
@@ -909,9 +910,11 @@ int snd_soc_put_xr_sx(struct snd_kcontro
 							regmask, regval);
 		if (err < 0)
 			return err;
+		if (err > 0)
+			ret = err;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_xr_sx);
 


