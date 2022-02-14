Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810074B4A1A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344078AbiBNJ6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:58:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344130AbiBNJz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:55:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D129D6CA54;
        Mon, 14 Feb 2022 01:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AD5461238;
        Mon, 14 Feb 2022 09:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C425C340E9;
        Mon, 14 Feb 2022 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831858;
        bh=VurFU58a1cNgjY+xlro4xnBrTwWyCaOg886ucNWiblY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9OYqlyq6Ke+GKhdGpR1+YtIRsBkmx86wu2BTZ3txipDIAmGLLuXFKrXkHr3mMH4v
         +0oXp6kKJARFDcqp5FQT8ihHs+BPfB8CKPAPIOJS39yzgWAvXwfggnnvtsGFg/157E
         kPY0qpgIbxWtIVvrIs0BTTvF+7ZtKCFms/LC6gD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.10 107/116] speakup-dectlk: Restore pitch setting
Date:   Mon, 14 Feb 2022 10:26:46 +0100
Message-Id: <20220214092502.487158091@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit bca828ccdd6548d24613d0cede04ada4dfb2f89c upstream.

d97a9d7aea04 ("staging/speakup: Add inflection synth parameter")
introduced the inflection parameter, but happened to drop the pitch
parameter from the dectlk driver. This restores it.

Cc: stable@vger.kernel.org
Fixes: d97a9d7aea04 ("staging/speakup: Add inflection synth parameter")
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20220206015626.aesbhvvdkmqsrbaw@begin
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/speakup_dectlk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accessibility/speakup/speakup_dectlk.c
+++ b/drivers/accessibility/speakup/speakup_dectlk.c
@@ -44,6 +44,7 @@ static struct var_t vars[] = {
 	{ CAPS_START, .u.s = {"[:dv ap 160] " } },
 	{ CAPS_STOP, .u.s = {"[:dv ap 100 ] " } },
 	{ RATE, .u.n = {"[:ra %d] ", 180, 75, 650, 0, 0, NULL } },
+	{ PITCH, .u.n = {"[:dv ap %d] ", 122, 50, 350, 0, 0, NULL } },
 	{ INFLECTION, .u.n = {"[:dv pr %d] ", 100, 0, 10000, 0, 0, NULL } },
 	{ VOL, .u.n = {"[:dv g5 %d] ", 86, 60, 86, 0, 0, NULL } },
 	{ PUNCT, .u.n = {"[:pu %c] ", 0, 0, 2, 0, 0, "nsa" } },


