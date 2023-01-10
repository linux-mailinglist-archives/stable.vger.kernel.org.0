Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094096648F0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbjAJSQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239032AbjAJSPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120AD1582D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF0ACB81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0406C433EF;
        Tue, 10 Jan 2023 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374441;
        bh=Q6JrCLq4Xrvr92tLcyK9c4mCTj7Px9T0ZwLJ8fiSQSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zb9Azfbk86vqu9z7VaAJteebc95ZkQM46AbtePm2WSJo3wHblda8tpHXRnvicDMK2
         LjWT6RiLUXu+ozzxaDqvd3zp1+YdaFxQJNijcMvuz4bBixda+m+AHHI3KOYjyqf21r
         N4Ie7xuGW7OPXVOiljzwTQfeXuMAU3DOE/WUlgLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/159] btrfs: replace strncpy() with strscpy()
Date:   Tue, 10 Jan 2023 19:02:30 +0100
Message-Id: <20230110180018.371262010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index 5ba2e810dc6e..fd1902573cde 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3750,13 +3750,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
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
index 5c1a617eb25d..5c2b66d155ef 100644
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



