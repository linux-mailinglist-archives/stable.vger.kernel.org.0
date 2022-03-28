Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F03E4E917B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbiC1JhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiC1JhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:37:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6972353B5F;
        Mon, 28 Mar 2022 02:35:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id w7so9392528pfu.11;
        Mon, 28 Mar 2022 02:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=3B0BaHG6k26aUp5O4LXFERLkhvlhsLzlL/Sw9dLemRY=;
        b=AyRjy4qQzhyj/OiPJW9T2yqRCPhHHPrMYfoliEeWGddjkznalqa+UU1uX6I1RfoMdo
         iWqMf1wJkpv/r9/S+PoNT8+BcfAiglZDcwX0iSN7KbA1uxpTW5tMlX+Lqx/H5nspY9cG
         LcG4ObEL4IoXBfwo4G7k6pax8vP37lMVzNh0JFY5DZPElbJblJGBJ08+CILa9aNPMFF8
         9GEeO21g/v8NV7OfpKk4uu4T6CDEc7XPi5xWAwLfclKxH14+VdCf6sJBLr9fZ/f2PL+6
         Nth4EEdTBucsOq26XfRYEKmpJtq9veyjTOkt8vrLk2ZbGxcA5GIX41WQ3iimvhZI0ksT
         Mi/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3B0BaHG6k26aUp5O4LXFERLkhvlhsLzlL/Sw9dLemRY=;
        b=F7sm6IfCewDwczRJ+eUTLHCBrUXlIY2upefUW7DLjN4FHQklMbZoZ5vfshq3hXrejU
         YFOoMRHW6tukW343nnE5g+CNhkxIGOfsjJe5vbv8zTYX2kRTq8jKP4M1RjYAL4LopDhR
         NAOu3rAZzR1mRm2G+C77ii8au6ILIuE6ClNZSBLRURrQSuEwQNILY3tWIzhHoKDLHx9N
         8xaiMhDE19SCilvCDljCiMSIzQRHkHGoALrB8ksKSV2eN1noyrF0WWOmx3+WcIigDOiW
         U7FIjjEJiEaPnCYcshmQPwAwElHscF1mn1/y0MDvZACIDYTJEaC017aIPLlYfT6a6pUn
         +gkQ==
X-Gm-Message-State: AOAM532r3v9oa4u5kiBfoyuX4dMspfnybzRh70cIsoMZUpsR+M09qydW
        ml2c+xJQJAYh4A7Qu+3q14s=
X-Google-Smtp-Source: ABdhPJzpPBQDh5IpBVKJ5xOlQxbHmE6kzjcbfZIiYxYf2aCDDETvbACiEND7IRuqT79DqLRv1kbd7w==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr22546248pfm.35.1648460119892;
        Mon, 28 Mar 2022 02:35:19 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id k6-20020a17090a7f0600b001c63352cadbsm13622541pjl.29.2022.03.28.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:35:19 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        jcmvbkbc@gmail.com, elder@linaro.org, dsterba@suse.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v3] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 17:35:05 +0800
Message-Id: <20220328093505.27902-1-xiam0nd.tong@gmail.com>
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
the 'if (s->len != flen) {' in theory iif s->len's value is flen,
or/and lead to an invalid memory access.

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

