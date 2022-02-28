Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605044C6382
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiB1HDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiB1HDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:03:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAEA55A2
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDF78B80E41
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE09C340E7;
        Mon, 28 Feb 2022 07:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646031743;
        bh=KNa8OiWi9/NJowyUFM8XMV+R/s8SVe+ejuKIsmICKKU=;
        h=Subject:To:Cc:From:Date:From;
        b=tecYXe+iDdjAiERPWJRgIGDCnf2RpDhnEC8/AgQ1BiU0pev0igLFcIAd436VS9PTS
         aSTyeoO44LLbTtJrFdUtZLnXJ5yIi5KmMhKV56TJhhv1SNE017WVgsn4KjmbcJ1kvw
         xWWcELPFoWPTucxxtLeXDjJnIenXtWXWJ9Ltyhdk=
Subject: FAILED: patch "[PATCH] staging: fbtft: fb_st7789v: reset display before" failed to apply to 4.14-stable tree
To:     oliver.graute@kococonnector.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:02:17 +0100
Message-ID: <1646031737160222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b6821b0d9b56386d2bf14806f90ec401468c799f Mon Sep 17 00:00:00 2001
From: Oliver Graute <oliver.graute@kococonnector.com>
Date: Thu, 10 Feb 2022 09:53:22 +0100
Subject: [PATCH] staging: fbtft: fb_st7789v: reset display before
 initialization

In rare cases the display is flipped or mirrored. This was observed more
often in a low temperature environment. A clean reset on init_display()
should help to get registers in a sane state.

Fixes: ef8f317795da (staging: fbtft: use init function instead of init sequence)
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
Link: https://lore.kernel.org/r/20220210085322.15676-1-oliver.graute@kococonnector.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/fbtft/fb_st7789v.c b/drivers/staging/fbtft/fb_st7789v.c
index abe9395a0aef..861a154144e6 100644
--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -144,6 +144,8 @@ static int init_display(struct fbtft_par *par)
 {
 	int rc;
 
+	par->fbtftops.reset(par);
+
 	rc = init_tearing_effect_line(par);
 	if (rc)
 		return rc;

