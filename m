Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905B66DEEE8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjDLIqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjDLIqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E0DE45
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5314630A5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEDC433D2;
        Wed, 12 Apr 2023 08:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289153;
        bh=h/ib6fl4TtyA/NRYPZ8C7rmlchiTo7y6V6Sl06s+cxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JQ7Uh14IlnFh8CgvACPduOjtAyw+FrZANdU7VqekeOtFTI85Fg/y/3scYCGmAj2j
         fIw/j8+HJ2DLe61DBGfilxxpUuFUn+9ell8ESh/llevqe78g+EXgN1QdNoLq5hhGkv
         bVDk8zJ5dVgpHSa1ShyFvpOx0gy+pD0E3ngPx8UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+502859d610c661e56545@syzkaller.appspotmail.com
Subject: [PATCH 6.1 156/164] maple_tree: fix mas_prev() and mas_find() state handling
Date:   Wed, 12 Apr 2023 10:34:38 +0200
Message-Id: <20230412082843.273659022@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 17dc622c7b0f94e49bed030726df4db12ecaa6b5 upstream.

When mas_prev() does not find anything, set the state to MAS_NONE.

Handle the MAS_NONE in mas_find() like a MAS_START.

Link: https://lkml.kernel.org/r/20230120162650.984577-7-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+502859d610c661e56545@syzkaller.appspotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4844,7 +4844,7 @@ static inline void *mas_prev_entry(struc
 
 	if (mas->index < min) {
 		mas->index = mas->last = min;
-		mas_pause(mas);
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 retry:
@@ -5906,6 +5906,7 @@ void *mas_prev(struct ma_state *mas, uns
 	if (!mas->index) {
 		/* Nothing comes before 0 */
 		mas->last = 0;
+		mas->node = MAS_NONE;
 		return NULL;
 	}
 
@@ -5996,6 +5997,9 @@ void *mas_find(struct ma_state *mas, uns
 		mas->index = ++mas->last;
 	}
 
+	if (unlikely(mas_is_none(mas)))
+		mas->node = MAS_START;
+
 	if (unlikely(mas_is_start(mas))) {
 		/* First run or continue */
 		void *entry;


