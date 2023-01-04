Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0B65D91E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjADQWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239521AbjADQVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:21:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305F38FFA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1D79617A9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AF1C433EF;
        Wed,  4 Jan 2023 16:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849289;
        bh=ksgXcK1NaxphJYJtafeiAOuNITTClBgyX0yxEtDAZWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S75GomysMdUjgcdiWN5ihfOl1wpCH7JiZxjN0iF4/aZeKnvWljMG9VjNQ42tCa7Bp
         n2zgJ9boUR8YK42+SVMNVR0yanYAeCHB4xsWp+I1Az8lrdN9DYMqxpauDnV+LS3nP7
         r1Y3SoiG1PvyeIUlwiM/AjPGPb8d4lY294nIUan0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@kernel.org>,
        syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.1 165/207] fs: ext4: initialize fsdata in pagecache_write()
Date:   Wed,  4 Jan 2023 17:07:03 +0100
Message-Id: <20230104160517.114442515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

commit 956510c0c7439e90b8103aaeaf4da92878c622f0 upstream.

When aops->write_begin() does not initialize fsdata, KMSAN reports
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
Reported-by: syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221121112134.407362-1-glider@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/verity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -79,7 +79,7 @@ static int pagecache_write(struct inode
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = aops->write_begin(NULL, mapping, pos, n, &page, &fsdata);


