Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB750F8A2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346220AbiDZJHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347645AbiDZJGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FBB15B95B;
        Tue, 26 Apr 2022 01:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B1B61344;
        Tue, 26 Apr 2022 08:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7FBC385A4;
        Tue, 26 Apr 2022 08:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962712;
        bh=Ppg4K5rXXT1fBHaPj0LOmFveIGcPWCF4xXq+qRCLGQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmySi+RxRHvUQEvwvBf2jFVyMc5imgwSf0U4P6/ALJOKtPr/DI26E8HrFmytO1W4s
         GRrK0Gl4/60lJ5lYg2aMKPuoE9yh8Td/8Ap6FGFTxrc0HkQEfu/NpbkymyYVgctG1r
         1sSjS7+5huGlyFIu1RLHj/GGx0WCR6CFYpNZd/l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cf4cf13056f85dec2c40@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 057/146] XArray: Disallow sibling entries of nodes
Date:   Tue, 26 Apr 2022 10:20:52 +0200
Message-Id: <20220426081751.671208688@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 63b1898fffcd8bd81905b95104ecc52b45a97e21 ]

There is a race between xas_split() and xas_load() which can result in
the wrong page being returned, and thus data corruption.  Fortunately,
it's hard to hit (syzbot took three months to find it) and often guarded
with VM_BUG_ON().

The anatomy of this race is:

thread A			thread B
order-9 page is stored at index 0x200
				lookup of page at index 0x274
page split starts
				load of sibling entry at offset 9
stores nodes at offsets 8-15
				load of entry at offset 8

The entry at offset 8 turns out to be a node, and so we descend into it,
and load the page at index 0x234 instead of 0x274.  This is hard to fix
on the split side; we could replace the entire node that contains the
order-9 page instead of replacing the eight entries.  Fixing it on
the lookup side is easier; just disallow sibling entries that point
to nodes.  This cannot ever be a useful thing as the descent would not
know the correct offset to use within the new node.

The test suite continues to pass, but I have not added a new test for
this bug.

Reported-by: syzbot+cf4cf13056f85dec2c40@syzkaller.appspotmail.com
Tested-by: syzbot+cf4cf13056f85dec2c40@syzkaller.appspotmail.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/xarray.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/xarray.c b/lib/xarray.c
index 88ca87435e3d..32e1669d5b64 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -207,6 +207,8 @@ static void *xas_descend(struct xa_state *xas, struct xa_node *node)
 	if (xa_is_sibling(entry)) {
 		offset = xa_to_sibling(entry);
 		entry = xa_entry(xas->xa, node, offset);
+		if (node->shift && xa_is_node(entry))
+			entry = XA_RETRY_ENTRY;
 	}
 
 	xas->xa_offset = offset;
-- 
2.35.1



