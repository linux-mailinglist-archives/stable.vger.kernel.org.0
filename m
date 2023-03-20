Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826EA6C1948
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjCTPc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjCTPcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:32:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042D32ED58
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BC33CE12F9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B0C433D2;
        Mon, 20 Mar 2023 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325866;
        bh=CrlgYa5+8GUkSasgpBUKSlDHJhu07CrQBRkPfPGcSoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYVtXGbjon0cDrkh1aLMpUz7ndgLHWEmgr2DcyvlACg8zkjNurvs7xh525eo+PPsN
         HlXajRNJCw69ynbP4hJFHlxG0TwGEeTkUKLJiC+ELbyX0KtOWW+3n6Gr07juCBbHrn
         0vW12x/rM9WpDgZDMuTXZoKduhl+0jRC5fAfYoSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        syzbot+0c73d1d8b952c5f3d714@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.2 116/211] ext4: fix possible double unlock when moving a directory
Date:   Mon, 20 Mar 2023 15:54:11 +0100
Message-Id: <20230320145518.185628193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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
@@ -3884,10 +3884,8 @@ static int ext4_rename(struct user_names
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


