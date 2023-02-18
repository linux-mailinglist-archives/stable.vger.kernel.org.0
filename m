Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7476369B87D
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 08:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBRHYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 02:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRHYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 02:24:00 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79ADB4CCB4;
        Fri, 17 Feb 2023 23:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eP1j+
        lElSPssDtSj8LwargtGGcq1VDnKNYy6CzlJ97A=; b=TUTdpuurF7NKVE9zcHweM
        JDKVn4+h83c/OOu+CGdgS+rnypzrKfYoba+KMdSpAjAf1tF88+XTMZ/5vXYwRQnr
        6DfLpuPo4aY1jlEwr0ejQjkQVWRDcSm+RRXbh4UJ6FAZ5Urxcj1N7DtWWPkxvGki
        OwibTAd+DehxvZ7QoyA10s=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wBH2wD4fPBjKPHnAA--.42777S2;
        Sat, 18 Feb 2023 15:23:36 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     colyli@suse.de
Cc:     hackerzheng666@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex000young@gmail.com, Zheng Wang <zyytlz.wz@163.com>,
        stable@vger.kernel.org
Subject: [RESEND PATCH v3] bcache: Fix __bch_btree_node_alloc to make the failure  behavior consistent
Date:   Sat, 18 Feb 2023 15:23:35 +0800
Message-Id: <20230218072335.1537099-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wBH2wD4fPBjKPHnAA--.42777S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWfCr45Kw47XFWDuF4DArb_yoW8JFWUpF
        W2gryFyF4Fgr4UAas3W3WjvFyrZ34jvFWYkas3Zw1FvrnrZrn3XFWjy3y0v345CFW8GF47
        Jr1rtw18Zr1jkF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziaiiDUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBuhgaU1+GuOaJqwABsP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some specific situation, the return value of __bch_btree_node_alloc may
be NULL. This may lead to poential NULL pointer dereference in caller
 function like a calling chaion :
 btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.

Fix it by initialize return value in __bch_btree_node_alloc before return.

Fixes: cafe56359144 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v3:
- Add Cc: stable@vger.kernel.org suggested by Eric
v2:
- split patch v1 into two patches to make it clearer suggested by Coly Li
---
 drivers/md/bcache/btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 147c493a989a..cae25e74b9e0 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
 				     struct btree *parent)
 {
 	BKEY_PADDED(key) k;
-	struct btree *b = ERR_PTR(-EAGAIN);
+	struct btree *b;
 
 	mutex_lock(&c->bucket_lock);
 retry:
+	/* return ERR_PTR(-EAGAIN) when it fails */
+	b = ERR_PTR(-EAGAIN);
 	if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
 		goto err;
 
-- 
2.25.1

