Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E266CBA2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjAPRPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjAPRPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F264CF76B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1870B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9BEC433EF;
        Mon, 16 Jan 2023 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888155;
        bh=TkCHzohUPlzyQLwONlqXBHNNlTGDGT5nySft9D7EbTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S85FKfR/8n0Ow/kpP08MJEGN6JW5KBxEAfNzSmrIMiGwuq8AcIRawNZZYsMG0zhn1
         ZOWsor4MDOOJ0suUelmUm1+iw4wHdKiGx8SFEWv9jZ2kCmKvBO2JcB1WKKYmb6cD5j
         YgLeTzTUOknLLYqu3ee2Pbjh7QSr3UeMCP17Ubvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 420/521] btrfs: replace strncpy() with strscpy()
Date:   Mon, 16 Jan 2023 16:51:22 +0100
Message-Id: <20230116154905.913186409@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 63d5429f68a3d4c4aa27e65a05196c17f86c41d6 ]

Using strncpy() on NUL-terminated strings are deprecated.  To avoid
possible forming of non-terminated string strscpy() should be used.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c      | 9 +++------
 fs/btrfs/rcu-string.h | 6 +++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 752b5d265284..4f2513388567 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3234,13 +3234,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		strncpy(di_args->path, rcu_str_deref(dev->name),
-				sizeof(di_args->path) - 1);
-		di_args->path[sizeof(di_args->path) - 1] = 0;
-	} else {
+	if (dev->name)
+		strscpy(di_args->path, rcu_str_deref(dev->name), sizeof(di_args->path));
+	else
 		di_args->path[0] = '\0';
-	}
 
 out:
 	rcu_read_unlock();
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
index a97dc74a4d3d..02f15321cecc 100644
--- a/fs/btrfs/rcu-string.h
+++ b/fs/btrfs/rcu-string.h
@@ -18,7 +18,11 @@ static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
 					 (len * sizeof(char)), mask);
 	if (!ret)
 		return ret;
-	strncpy(ret->str, src, len);
+	/* Warn if the source got unexpectedly truncated. */
+	if (WARN_ON(strscpy(ret->str, src, len) < 0)) {
+		kfree(ret);
+		return NULL;
+	}
 	return ret;
 }
 
-- 
2.35.1



