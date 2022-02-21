Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1AF4BE53A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346984AbiBUJDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347192AbiBUJA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655A27B2E;
        Mon, 21 Feb 2022 00:56:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5A63B80EAF;
        Mon, 21 Feb 2022 08:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBA9C340E9;
        Mon, 21 Feb 2022 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433760;
        bh=XNcZJD8WoDEQAQnmMUE/R3Xrqgj7fY2o72ZslMisX7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2sVU+G2mtBjWBcoVjXuCwr0d5MWF5JJSYoKCG1mXVmhriI1aBITZqtbTHij1Bv9+
         x4M7L7zS5lGgv49IbtsLNhWEEhIUGNZHRY3SXCFocF5u056thYJizsIgUwbw3xKW9p
         30yC5XqUQL/5qCQWpw637X6DFm6u8wQaKbqSvFJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 33/58] ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()
Date:   Mon, 21 Feb 2022 09:49:26 +0100
Message-Id: <20220221084912.949334538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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

commit 564778d7b1ea465f9487eedeece7527a033549c5 upstream.

When writing out a stereo control we discard the change notification from
the first channel, meaning that events are only generated based on changes
to the second channel. Ensure that we report a change if either channel
has changed.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220201155629.120510-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -314,7 +314,7 @@ int snd_soc_put_volsw(struct snd_kcontro
 	unsigned int sign_bit = mc->sign_bit;
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
-	int err;
+	int err, ret;
 	bool type_2r = false;
 	unsigned int val2 = 0;
 	unsigned int val, val_mask;
@@ -356,12 +356,18 @@ int snd_soc_put_volsw(struct snd_kcontro
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
 	if (err < 0)
 		return err;
+	ret = err;
 
-	if (type_2r)
+	if (type_2r) {
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
-			val2);
+						    val2);
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
+	}
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_volsw);
 


