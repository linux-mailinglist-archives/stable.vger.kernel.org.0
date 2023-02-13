Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79253694968
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjBMO6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjBMO6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC141DB9F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C7C6115E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4ADC4339E;
        Mon, 13 Feb 2023 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300251;
        bh=r/OMLJzhlrHg+5uzhwT/c328dR87L/lltmas73C3t4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/4I7nh840XHUEBNEva4nJypFa7KiwhQdu4w17skYHLiaBluCkXmPUSNPsuglSqiF
         VBkebDICSguUVvXQ+KvebcjsTcSpYpZlNH00uDIDyu15BiI3yCCoO8UjLIUAKsiQAT
         OaiKOQHCbqflwQj9HINlN8Jjs6rbu8c3XeHugy78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 07/67] btrfs: zlib: zero-initialize zlib workspace
Date:   Mon, 13 Feb 2023 15:48:48 +0100
Message-Id: <20230213144732.658331810@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

commit eadd7deca0ad8a83edb2b894d8326c78e78635d6 upstream.

KMSAN reports uses of uninitialized memory in zlib's longest_match()
called on memory originating from zlib_alloc_workspace().
This issue is known by zlib maintainers and is claimed to be harmless,
but to be on the safe side we'd better initialize the memory.

Link: https://zlib.net/zlib_faq.html#faq36
Reported-by: syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zlib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -63,7 +63,7 @@ struct list_head *zlib_alloc_workspace(u
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
-	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
+	workspace->strm.workspace = kvzalloc(workspacesize, GFP_KERNEL);
 	workspace->level = level;
 	workspace->buf = NULL;
 	/*


