Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94B4AACD7
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 23:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiBEWNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 17:13:34 -0500
Received: from mx-out.tlen.pl ([193.222.135.175]:47673 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbiBEWNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Feb 2022 17:13:34 -0500
Received: (wp-smtpd smtp.tlen.pl 31459 invoked from network); 5 Feb 2022 23:13:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1644099210; bh=Dj61o4Pce2pLcAW3DiuxixA3IJrOjC+xvJNNzVrDeuU=;
          h=From:To:Cc:Subject;
          b=Llcyuf/6f/2Pn8PCMeyiyQqu9iZFr4eYji4a6rPah/kVA1pP52AHudfPgI99U4q6B
           xcx9LEr+pHn4WQ1/uoDwxq4qhWvZKa/yluTQ6YGf3wQosfNRGEq3OSC2lIjG4ZXI1x
           CYWvI+bdxT//y4yWBZL7INU73Sp5TBE9FGI15mlA=
Received: from aafj183.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.4.139.183])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <stable@vger.kernel.org>; 5 Feb 2022 23:13:29 +0100
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     stable@vger.kernel.org, linux-rtc@vger.kernel.org
Cc:     Riwen Lu <luriwen@kylinos.cn>, Eric Wong <e@80x24.org>,
        =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH] rtc: cmos: Evaluate century appropriate
Date:   Sat,  5 Feb 2022 23:11:39 +0100
Message-Id: <20220205221139.5557-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 760e4fd0c36709f153317bc606c92697
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [4QMk]                               
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
---
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Hello,

I have prepared this patch for inclusion into stable. Run-tested on top
of 5.16.7 and 4.9.299, works as intended.

Greetings,
Mateusz

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index dcfaf09946ee..2065842f775d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -104,7 +104,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	time->tm_year += real_year - 72;
 #endif
 
-	if (century > 20)
+	if (century > 19)
 		time->tm_year += (century - 19) * 100;
 
 	/*
-- 
2.25.1

