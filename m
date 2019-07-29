Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8D5797D0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390129AbfG2TqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389627AbfG2TqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A3F217D7;
        Mon, 29 Jul 2019 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429584;
        bh=3N7p1PM00csEyJLS9KFJaSXdvGKRGzUML6K5QMs3g8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JN5bQkNMVIjDdseKsNfoJiTLpdeDYrDSdAQybnliHKR7cmybrsO0tm2I00hD9Zlb4
         d1OYFCTctnPbOscnNIjmVNJNY1mYUYiv0ar4kXqb/lI6Ay3U8ND1QO+pPp0tzr9RsR
         CpqUu+KMZ9P4j9Z8SMnsbThhpnxTfuA0flpV6mlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 003/215] btrfs: shut up bogus -Wmaybe-uninitialized warning
Date:   Mon, 29 Jul 2019 21:19:59 +0200
Message-Id: <20190729190740.374967721@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 6c64460cdc8be5fa074aa8fe2ae8736d5792bdc5 upstream.

gcc sometimes can't determine whether a variable has been initialized
when both the initialization and the use are conditional:

fs/btrfs/props.c: In function 'inherit_props':
fs/btrfs/props.c:389:4: error: 'num_bytes' may be used uninitialized in this function [-Werror=maybe-uninitialized]
    btrfs_block_rsv_release(fs_info, trans->block_rsv,

This code is fine. Unfortunately, I cannot think of a good way to
rephrase it in a way that makes gcc understand this, so I add a bogus
initialization the way one should not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Sterba <dsterba@suse.com>
[ gcc 8 and 9 don't emit the warning ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/props.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -337,7 +337,7 @@ static int inherit_props(struct btrfs_tr
 	for (i = 0; i < ARRAY_SIZE(prop_handlers); i++) {
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
-		u64 num_bytes;
+		u64 num_bytes = 0;
 
 		if (!h->inheritable)
 			continue;


