Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011764B4614
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbiBNJ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243037AbiBNJ2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DD760D8E;
        Mon, 14 Feb 2022 01:28:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3154260F6F;
        Mon, 14 Feb 2022 09:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15234C340E9;
        Mon, 14 Feb 2022 09:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830920;
        bh=4uuCJjkSrfPwVS+0znzdwJlAn7nz7c2ExeWvq/SGEMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwTf85Kt0sTJ1xqhXrc1RSnI3J5W9auYwjKc54oDca7wA6gpiQsoRx6kzfPi7Sb8I
         U9ftMbh8kX2Xs7kVPUxNO4tGfDBHsQpSgsXv60i3YiqqlE8DtMJIsWhXXEUAOVybgj
         Mb+V8G1T4tSwHNDQRtSCKRmfuJGwcJqO/bKECp3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.9 07/34] ALSA: line6: Fix misplaced backport of "Fix wrong altsetting for LINE6_PODHD500_1"
Date:   Mon, 14 Feb 2022 10:25:33 +0100
Message-Id: <20220214092446.188220247@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
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

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

The upstream commit 70256b42caaf ("ALSA: line6: Fix wrong altsetting for
LINE6_PODHD500_1") changed the .altsetting field of the LINE6_PODHD500_1
entry in podhd_properties_table from 1 to 0.

However, its backported version in stable (commit ec565611f930 ("ALSA:
line6: Fix wrong altsetting for LINE6_PODHD500_1")) change the
.altsetting field of the LINE6_PODHD500_0 entry instead.

This patch resets the altsetting of LINE6_PODHD500_0 to 1, and sets the
altsetting of LINE6_PODHD500_1 to 0, as wanted by the original fix.

Fixes: ec565611f930 ("ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/podhd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -385,7 +385,7 @@ static const struct line6_properties pod
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 0,
+		.altsetting = 1,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,
@@ -396,7 +396,7 @@ static const struct line6_properties pod
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 1,
+		.altsetting = 0,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,


