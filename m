Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037254E9641
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 14:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiC1MMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 08:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiC1MMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 08:12:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4E94616F;
        Mon, 28 Mar 2022 05:10:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b13so10564674pfv.0;
        Mon, 28 Mar 2022 05:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=2metHrwiTDvTKdu2SsVynM27Kre3NRcfjJWJDziOK2s=;
        b=bzLn/vTVd5csLlxLA8U14K6h6AVYNc/RaTCL2SCqxZTGmJhDLexAqiu40rUPlPJZ1+
         EHWKGGcoIbJahNJfKHYl2GmXvEEh/DG4QQU3qzKFMvpmk8SpWzz8+7o4Bngn6iyBi8Ve
         danmjzuRezT1r5HfS/9olEugghGy+AeI8c0u0S27K2MSwonGfyIbrT3MokDmYeUpBQvg
         yukIigRDeqY43PseXtn6zKUJicPkatL5bHwzS/DgzBkOIDTgPBkTZKrljs2upSPCgC7Z
         +3d8QpUx0l5hx3m7IVcCXLP6I9jH1aHPEQc7l2F00tRVfLFApTyLBA2RQP3GMUfsZVWT
         BczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2metHrwiTDvTKdu2SsVynM27Kre3NRcfjJWJDziOK2s=;
        b=a4McFD4uiEotbtyuCI+B7NmMjK6KX4Lzn66HRye00zZdDPkF95a0AU2KIJYsojxgCZ
         PH+sH+NIGIN4i+BZJeFycKIyjJPVFrmHNmL/oSwG+FFN6rM7ni8vZsmnWBUgTbNwDDGS
         nhOos70RazISFoE7V3Aja7m+rqtB0r/Sgv2rL25p1ELRcShaC8sqnIXmRXuR9wPgovXV
         9TqpQj3rhGZ1KrKw72+sojyZX9DF85RwtPOtbVEsjsDKjKWsctl0UHoUQYMPSyKNXy5H
         Rg2drkoS0toBDE4c1V0BCIHFghfjm4QN2/AnfMgiEzNMyl7gsV/bsr0HsLHEsMBPhGTs
         wswg==
X-Gm-Message-State: AOAM530VHGQBFYkuF55pTBNw29jxpoaRbYyYuv73mPI20q/gxj756Tc4
        cpV8Wwt5Ib/nGJ1soL41SnA3VKEC1vC4AA==
X-Google-Smtp-Source: ABdhPJyNkvB3SXX6Y53tt18jSoLf0RY9GAqt/vx5zeQ2C0Q++J31WoyKZlVWfJrEAe8oSoT2nr33MQ==
X-Received: by 2002:a63:770c:0:b0:386:361f:ecce with SMTP id s12-20020a63770c000000b00386361feccemr10162135pgc.202.1648469442425;
        Mon, 28 Mar 2022 05:10:42 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id p10-20020a056a0026ca00b004fb44e0cb17sm5528250pfw.116.2022.03.28.05.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:10:41 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        jcmvbkbc@gmail.com, elder@linaro.org, dsterba@suse.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v3] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 20:10:30 +0800
Message-Id: <20220328121030.32047-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (s->len != flen) {

The list iterator 's' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it may bypass
the 'if (s->len != flen) {' in theory if s->len's value is flen,
or/and lead to an invalid memory access lately.

To fix this bug, use a new variable 'iter' as the list iterator,
while using the origin variable 's' as a dedicated pointer to
point to the found element. And if the list is empty or no element
is found, WARN_ON and return.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
changes since v2:
 - WARN_ON and return (Sven Schnelle)

changes since v1:
 - reallocate s when s == NULL (Sven Schnelle)

v1:https://lore.kernel.org/lkml/20220327064931.7775-1-xiam0nd.tong@gmail.com/
v2:https://lore.kernel.org/lkml/20220328070543.24671-1-xiam0nd.tong@gmail.com/

---
 drivers/s390/char/tty3270.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 5c83f71c1d0e..9d0952178322 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1109,9 +1109,9 @@ static void tty3270_put_character(struct tty3270 *tp, char ch)
 static void
 tty3270_convert_line(struct tty3270 *tp, int line_nr)
 {
+	struct string *s = NULL, *n, *iter;
 	struct tty3270_line *line;
 	struct tty3270_cell *cell;
-	struct string *s, *n;
 	unsigned char highlight;
 	unsigned char f_color;
 	char *cp;
@@ -1142,9 +1142,14 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
 
 	/* Find the line in the list. */
 	i = tp->view.rows - 2 - line_nr;
-	list_for_each_entry_reverse(s, &tp->lines, list)
-		if (--i <= 0)
+	list_for_each_entry_reverse(iter, &tp->lines, list)
+		if (--i <= 0) {
+			s = iter;
 			break;
+		 }
+
+	if(WARN_ON(!s))
+		return;
 	/*
 	 * Check if the line needs to get reallocated.
 	 */
-- 
2.17.1

