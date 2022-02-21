Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76184BE686
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbiBUJyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:54:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352265AbiBUJxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC12D36B78;
        Mon, 21 Feb 2022 01:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82E41B80EB8;
        Mon, 21 Feb 2022 09:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51B4C340E9;
        Mon, 21 Feb 2022 09:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435406;
        bh=3fs6oNe7Ko7oVKXh9CVZYXEcEJvtYZ0K6qMFrb5P8Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcjZSbD9OFKsMnNnF8to3UcNVUe1hPtg9yAGB5+q53vstV2eKutbZvU2X+kUUB6FY
         sz8YS+HxtNTBaYdmRQuSBxAWHAaTnQpxrArYht0hdg44n0sOb4lrXmHRm6jfg3YpAP
         4bSnt4iO1nEec71duk+6McKwMQTvv5WdSYbEE8WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 145/227] ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_sx()
Date:   Mon, 21 Feb 2022 09:49:24 +0100
Message-Id: <20220221084939.655132365@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

commit 7f3d90a3519680dfa23e750f80bfdefc0f5eda4a upstream.

When writing out a stereo control we discard the change notification from
the first channel, meaning that events are only generated based on changes
to the second channel. Ensure that we report a change if either channel
has changed.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220201155629.120510-3-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -427,6 +427,7 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 	int min = mc->min;
 	unsigned int mask = (1U << (fls(min + max) - 1)) - 1;
 	int err = 0;
+	int ret;
 	unsigned int val, val_mask;
 
 	val = ucontrol->value.integer.value[0];
@@ -443,6 +444,7 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
 	if (err < 0)
 		return err;
+	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		unsigned int val2;
@@ -453,6 +455,11 @@ int snd_soc_put_volsw_sx(struct snd_kcon
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
 			val2);
+
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
 	}
 	return err;
 }


