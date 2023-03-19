Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF36C038E
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCSRpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 13:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSRpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 13:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191177694;
        Sun, 19 Mar 2023 10:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 989D96114C;
        Sun, 19 Mar 2023 17:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046BDC4339B;
        Sun, 19 Mar 2023 17:45:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GE4SLUng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1679247911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NPvppMs7hIAjP7HnzZbcvA8mozFJnzzU75xW+9OQ5vo=;
        b=GE4SLUngXG83sw3VZDsQ624tk1I/iXUJnpNn7Ebx3+W/rtnJaCmAiQr888B+3MqfZdFhr2
        abQv6qdqKlwWbvneIX+z11npO4uM1f0OW8nP8kdVYr8vsanDht0Jh0qzFlMDNuVrGKaBcE
        p3fxg2eQGBtYTlzL+5du1w47lLvy6Wk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9f647f71 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 19 Mar 2023 17:45:11 +0000 (UTC)
Date:   Sun, 19 Mar 2023 18:45:08 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     msizanoen <msizanoen@qtmlabs.xyz>
Cc:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: alps: fix compatibility with -funsigned-char
Message-ID: <ZBdKJJ+HJaB0mdNR@zx2c4.com>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Might be wise to clean up a few other ones in that file? Or not. Up to
you:

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 989228b5a0a4..afbf67c2488a 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 			x = y = z = 0;

 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (signed char)x / 4);
+		input_report_rel(dev2, REL_Y, -((signed char)y / 4));

 		psmouse_report_standard_buttons(dev2, packet[3]);

@@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);

-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (signed char)x);
+	input_report_rel(dev2, REL_Y, -((signed char)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);

 	psmouse_report_standard_buttons(dev2, packet[1]);
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index 5f0d75a45c80..43a1116c5852 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -382,7 +382,7 @@ static unsigned int elan_convert_resolution(u8 val, u8 pattern)
 	 *	((value from firmware) + 3) * 100 = dpi
 	 */
 	int res = pattern <= 0x01 ?
-		(int)(char)val * 10 + 790 : ((int)(char)val + 3) * 100;
+		(int)(signed char)val * 10 + 790 : ((int)(signed char)val + 3) * 100;
 	/*
 	 * We also have to convert dpi to dots/mm (*10/254 to avoid floating
 	 * point).
