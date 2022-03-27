Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9C24E8655
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiC0GvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiC0GvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:51:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250223888;
        Sat, 26 Mar 2022 23:49:38 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v4so11215381pjh.2;
        Sat, 26 Mar 2022 23:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ymIvNnjuLqMnCvalw02zjCVgpb+/pNa29hFYChi9Jf8=;
        b=GUyU8k523t/Ldfz8b02PNbIefrS2rcg2k5EJEIvUmom8+bFgFN8VPBidLc29fMv4KL
         Q9DI4siZcZF8mSB/ZZefU202taICAy0eC/vyuW1GUgnSni5Qj8eOIGzWFVIjXr5Z5RKo
         p9ZHycB4L1ne43q7MqG4dwBtVYT5aQyLfPY0zojm67lp3FTNcXCM5muc7h5b0+eLJ7tV
         baPwqQbk3QoitoOoO75U9cbpDc9rRz+e8vRsR3iGeNNYCfhseLdq0xX8JxZB+QnR/01W
         1y/ox5cRURo7DFlLT6LkL0LhbtNNE4v/4k1s82Sm06jKJ/xkxhzyc0q0EN0buRd5DKL/
         82TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ymIvNnjuLqMnCvalw02zjCVgpb+/pNa29hFYChi9Jf8=;
        b=I9t6aROLhrgjdCNI1DLcNPpywT5FcOzUDYprzbYcpK1P3eFZgyDGU/AJAKmmNrMCKQ
         KBui32fbOxfVluygXa8ZOiRbcdkYUhY9KjFSl4cvKybx3pduNFX9cjZiRNEs1VVlEpzA
         aeAW20xhZ8eIFnkakLdAM/fO3tWHcarw4J8Lx/FEfSX/+CwqQGMcxrGB+UoeYRNPnMoL
         uW5LrVnqFFeZbBTEYg7YLWeERL5UYyWV3Ng/RausrZ/PkYzmadhlYb8PXcUkSxlYtb98
         DvgkdyKNOBVlHFG7roXFLq/DplVcFB4bOM+x7Rj10fIuJPPu8O0pgMKu44zdEe7yEHF6
         zFeA==
X-Gm-Message-State: AOAM531BveP7Rr0ubsV50JXpMjIMyIvEsdN0f5x6v7WfKQYYfq6xlyKW
        bo9d61HERy0Fdu28YY3Nu2CUOInCiFk=
X-Google-Smtp-Source: ABdhPJwQZY4aZNopnSm6wS+PPNF5L61PGQwGtvcGHjoDufxDqN8Q0CQB0qBYQqwlmGfFKQ5Tw14Y+A==
X-Received: by 2002:a17:90a:4bc2:b0:1b8:cdd3:53e2 with SMTP id u2-20020a17090a4bc200b001b8cdd353e2mr33924832pjl.219.1648363777683;
        Sat, 26 Mar 2022 23:49:37 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm12917685pfl.141.2022.03.26.23.49.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Mar 2022 23:49:37 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     hca@linux.ibm.com
Cc:     gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        jcmvbkbc@gmail.com, dsterba@suse.com, elder@linaro.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] char: tty3270: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 14:49:31 +0800
Message-Id: <20220327064931.7775-1-xiam0nd.tong@gmail.com>
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
be checked before any use of the iterator, otherwise it may bpass
the 'if (s->len != flen) {' in theory iif s->len's value is flen.

To fix this bug, use a new variable 'iter' as the list iterator,
while use the origin variable 's' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/s390/char/tty3270.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 5c83f71c1d0e..030e9a098d11 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1111,7 +1111,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
 {
 	struct tty3270_line *line;
 	struct tty3270_cell *cell;
-	struct string *s, *n;
+	struct string *s = NULL, *n, *iter;
 	unsigned char highlight;
 	unsigned char f_color;
 	char *cp;
@@ -1142,13 +1142,15 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
 
 	/* Find the line in the list. */
 	i = tp->view.rows - 2 - line_nr;
-	list_for_each_entry_reverse(s, &tp->lines, list)
-		if (--i <= 0)
+	list_for_each_entry_reverse(iter, &tp->lines, list)
+		if (--i <= 0) {
+			s = iter;
 			break;
+		}
 	/*
 	 * Check if the line needs to get reallocated.
 	 */
-	if (s->len != flen) {
+	if (!s || s->len != flen) {
 		/* Reallocate string. */
 		n = tty3270_alloc_string(tp, flen);
 		list_add(&n->list, &s->list);
-- 
2.17.1

