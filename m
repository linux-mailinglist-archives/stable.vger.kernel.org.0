Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6875490E5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354702AbiFMMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355282AbiFMMXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:23:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD9531530;
        Mon, 13 Jun 2022 04:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6EF61435;
        Mon, 13 Jun 2022 11:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C18DC34114;
        Mon, 13 Jun 2022 11:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118275;
        bh=hUNx9CZjR1LIuSKxLgjbKC/nXLk8yQ38+RhSvQnVqY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJJ6WVKRRPLW2f3yfSVbFFeVakSWdt+2FAbDrY+GoU1xnsK6HN/BS6GFq1SL3AvOw
         /MpZvqNXDxKXr3gH07KZkFtkQzThT4VpmglI2SgGkEnYHc11uOLci3CpdKk6/HgDeg
         I/NPoVgBSVlqQNfPPQUUja02AHYVGmYnH8jB9cpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/172] misc: fastrpc: fix an incorrect NULL check on list iterator
Date:   Mon, 13 Jun 2022 12:09:37 +0200
Message-Id: <20220613094854.530418986@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit 5ac11fe03a0a83042d1a040dbce4fa2fb5521e23 ]

The bug is here:
	if (!buf) {

The list iterator value 'buf' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty (in this case, the
check 'if (!buf) {' will always be false and never exit expectly).

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'buf' as a dedicated pointer to
point to the found element.

Fixes: 2419e55e532de ("misc: fastrpc: add mmap/unmap support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220327062202.5720-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index d0471fec37fb..65f24b6150aa 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1349,17 +1349,18 @@ static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
 				   struct fastrpc_req_munmap *req)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_buf *buf, *b;
+	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_munmap_req_msg req_msg;
 	struct device *dev = fl->sctx->dev;
 	int err;
 	u32 sc;
 
 	spin_lock(&fl->lock);
-	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
-		if ((buf->raddr == req->vaddrout) && (buf->size == req->size))
+	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
+		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
+			buf = iter;
 			break;
-		buf = NULL;
+		}
 	}
 	spin_unlock(&fl->lock);
 
-- 
2.35.1



