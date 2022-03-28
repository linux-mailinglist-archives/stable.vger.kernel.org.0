Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4CA4E8EA8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiC1HHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiC1HHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:07:39 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7BD31905;
        Mon, 28 Mar 2022 00:05:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n18so14003959plg.5;
        Mon, 28 Mar 2022 00:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=c9p/yTth/gXtGmPEKheuqeOpzukbOVJI5KRAEgn4bXk=;
        b=iOojkmWPYX1LhWSMkV0ItSY9kHBI9YOq+k3mg/XYeZMN4pItMfxEDQ4TMgXW18QZ1Y
         azXKMYcJjI26rpwtTIYWqkJNe2IWUKa+vzQtwwCx+nD0Ix6I1L3CInx+GECNq4mtGAiv
         1lIznC66kBbddpSjykNlG/Dv3A8c8J+3U8rJS6ft4fqa7VJjIUsy+qL6SmGH+SOdf7/A
         dfbF+K/4jdbVB7WS/8RUA4/j2YDUtlHVOaGGTtWbGjDyP2NI1sIyjrSD5VSqQR44hPZu
         PVqcD6JLAxJ7EdAEQNU7sMZaKV0yIwvnRaTF6WO1tT4JTSa2l0+SIbpnSTjVgrgZHyoM
         swUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c9p/yTth/gXtGmPEKheuqeOpzukbOVJI5KRAEgn4bXk=;
        b=XQH4IgQLEs3rxHdroztET9BfG/18C/CTDcweNuTp3Gj7GYdp8goExSPxgv1TTcrv8Q
         IPlJMM7s/O0WNT2JT2gjgutf8mCdvK3tfgwQJ01U6S9ZjslRgq/V6zPoLcZTYVUJEecn
         jbqumXXVeY/bS6AsuUGk4/DkxnJ/Dmua1wdSSx0NxbMhadl068TDe3xHPKLHHeyM5teG
         nY0nMDmBNfry3rFu2oKpLjAHi1Qf9i6bhY1byUlSPBqF0t78V5XlR6H95SGcvISbk48F
         GjnIMdm4n+OfEMGDBADdd/2dzznBPzPlTHBrLYbvclzeRALQ7HNuJ4BnoZp2Sjyja6Kw
         QSDA==
X-Gm-Message-State: AOAM530NdquHW040vrpp7AgCUhCJi31e91c7w85TLKJPHh7RVIMEA1z5
        ECTc6rVgNHv9KkT99xlU1iE=
X-Google-Smtp-Source: ABdhPJwGX+5miZyTmx71tINvkiLZNBk2iqKSsZbqTI4us+ZLB5E7DeNUsR53R50X5p4+jKV6bPqnGg==
X-Received: by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id s2-20020a170902a50200b0015182890b19mr24836440plq.149.1648451156631;
        Mon, 28 Mar 2022 00:05:56 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id f15-20020a056a001acf00b004fb2ad05521sm7087064pfv.215.2022.03.28.00.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 00:05:55 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        jcmvbkbc@gmail.com, elder@linaro.org, dsterba@suse.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 15:05:43 +0800
Message-Id: <20220328070543.24671-1-xiam0nd.tong@gmail.com>
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
is found, reallocate s.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - reallocate s when s == NULL (Sven Schnelle)

v1:https://lore.kernel.org/lkml/20220327064931.7775-1-xiam0nd.tong@gmail.com/

---
 drivers/s390/char/tty3270.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 5c83f71c1d0e..719e04dff63e 100644
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
@@ -1142,13 +1142,20 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
 
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
+	if (!s) {
+		/* Reallocate string. */
+		n = tty3270_alloc_string(tp, flen);
+		list_add(&n->list, &tp->lines);
+		s = n;
+	} else if (s->len != flen) {
 		/* Reallocate string. */
 		n = tty3270_alloc_string(tp, flen);
 		list_add(&n->list, &s->list);
-- 
2.17.1

