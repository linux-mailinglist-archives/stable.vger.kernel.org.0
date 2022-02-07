Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AE34ABDAD
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388973AbiBGLpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377754AbiBGLfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638DEC03FEC8;
        Mon,  7 Feb 2022 03:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D62E260180;
        Mon,  7 Feb 2022 11:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E11C004E1;
        Mon,  7 Feb 2022 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233739;
        bh=DFsm60ujwlq6xrmRluf3V0gZYV+0uKA4KIhEf3z/2VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODjv018DgL4WC527PwuUfriM21P3W+DY7QmWol6Nv8tcIKGfRw7XMhztC4ewTrqry
         64dPLMpyuND8FDRAnMIddDMGjnqjpkYRsXEuCniR8PkNu/QPhRJK+E6YtgqhThLbGx
         jxTHPHEAp0N//JuKPATpbGTgMWan9LToxGwZtez4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riwen Lu <luriwen@kylinos.cn>,
        Eric Wong <e@80x24.org>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.16 106/126] rtc: cmos: Evaluate century appropriate
Date:   Mon,  7 Feb 2022 12:07:17 +0100
Message-Id: <20220207103807.720623227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Riwen Lu <luriwen@kylinos.cn>

commit ff164ae39b82ee483b24579c8e22a13a8ce5bd04 upstream.

There's limiting the year to 2069. When setting the rtc year to 2070,
reading it returns 1970. Evaluate century starting from 19 to count the
correct year.

$ sudo date -s 20700106
Mon 06 Jan 2070 12:00:00 AM CST
$ sudo hwclock -w
$ sudo hwclock -r
1970-01-06 12:00:49.604968+08:00

Fixes: 2a4daadd4d3e5071 ("rtc: cmos: ignore bogus century byte")

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Acked-by: Eric Wong <e@80x24.org>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220106084609.1223688-1-luriwen@kylinos.cn
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl> # preparation for stable
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -104,7 +104,7 @@ again:
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century > 20)
+	if (century > 19)
 		time->tm_year += (century - 19) * 100;
 
 	/*


