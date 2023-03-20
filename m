Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9776C6C17F8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjCTPTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjCTPSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:18:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE07B2FCCE
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091CFB80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E4EC4339B;
        Mon, 20 Mar 2023 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325163;
        bh=w7ncPlp2FMxPWW8bhuvD7WOkeGLvgIrCC3mbaCLn7j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4M765DdxXDrIhf2qOS1rpJDzk+7OLX5Qs2llblytmrInPfxqd5/fangPK7P3TzWM
         dosbue09fQhCNyMivbJZdVb0S4O45SnRdi7PUWM7K7HxJJ/HpbumcdFGVBO22YHV0p
         KaY+WKX82AS98rfnHZkvA5ZpXrsgCE0cBZfRFwiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 073/115] ext4: fix possible double unlock when moving a directory
Date:   Mon, 20 Mar 2023 15:54:45 +0100
Message-Id: <20230320145452.492954755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 70e42feab2e20618ddd0cbfc4ab4b08628236ecd upstream.

Fixes: 0813299c586b ("ext4: Fix possible corruption when moving a directory")
Link: https://lore.kernel.org/r/5efbe1b9-ad8b-4a4f-b422-24824d2b775c@kili.mountain
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3898,10 +3898,8 @@ static int ext4_rename(struct user_names
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval) {
-			inode_unlock(old.inode);
+		if (retval)
 			goto end_rename;
-		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or


