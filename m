Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8672E24B45B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgHTKEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbgHTKCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EC520724;
        Thu, 20 Aug 2020 10:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917727;
        bh=sWjWwfjD7flakOy6N68TgJl+qcKvm9h/87QBngaZ2ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glfF/Eb3suI7xKjWkQGvYSEC9ZqgSICYlhvofV3QXbeRCRH1mtL/JjQHL4bnM/r2D
         P4mVSzzqwR0R995sp1Kx0D0pVljUBGgTUrXzjNYalK26QArKuJkc7TG8Lz8UqAeQJ0
         Gw2MkKmIx+xJPiE09nSrDCelGsv7e5+OzPaLNCwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/212] bcache: fix super block seq numbers comparision in register_cache_set()
Date:   Thu, 20 Aug 2020 11:21:18 +0200
Message-Id: <20200820091607.655461070@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 117f636ea695270fe492d0c0c9dfadc7a662af47 ]

In register_cache_set(), c is pointer to struct cache_set, and ca is
pointer to struct cache, if ca->sb.seq > c->sb.seq, it means this
registering cache has up to date version and other members, the in-
memory version and other members should be updated to the newer value.

But current implementation makes a cache set only has a single cache
device, so the above assumption works well except for a special case.
The execption is when a cache device new created and both ca->sb.seq and
c->sb.seq are 0, because the super block is never flushed out yet. In
the location for the following if() check,
2156         if (ca->sb.seq > c->sb.seq) {
2157                 c->sb.version           = ca->sb.version;
2158                 memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
2159                 c->sb.flags             = ca->sb.flags;
2160                 c->sb.seq               = ca->sb.seq;
2161                 pr_debug("set version = %llu\n", c->sb.version);
2162         }
c->sb.version is not initialized yet and valued 0. When ca->sb.seq is 0,
the if() check will fail (because both values are 0), and the cache set
version, set_uuid, flags and seq won't be updated.

The above problem is hiden for current code, because the bucket size is
compatible among different super block version. And the next time when
running cache set again, ca->sb.seq will be larger than 0 and cache set
super block version will be updated properly.

But if the large bucket feature is enabled,  sb->bucket_size is the low
16bits of the bucket size. For a power of 2 value, when the actual
bucket size exceeds 16bit width, sb->bucket_size will always be 0. Then
read_super_common() will fail because the if() check to
is_power_of_2(sb->bucket_size) is false. This is how the long time
hidden bug is triggered.

This patch modifies the if() check to the following way,
2156         if (ca->sb.seq > c->sb.seq || c->sb.seq == 0) {
Then cache set's version, set_uuid, flags and seq will always be updated
corectly including for a new created cache device.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 526e9d5a4fb16..2c976cf361984 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1778,7 +1778,14 @@ static const char *register_cache_set(struct cache *ca)
 	    sysfs_create_link(&c->kobj, &ca->kobj, buf))
 		goto err;
 
-	if (ca->sb.seq > c->sb.seq) {
+	/*
+	 * A special case is both ca->sb.seq and c->sb.seq are 0,
+	 * such condition happens on a new created cache device whose
+	 * super block is never flushed yet. In this case c->sb.version
+	 * and other members should be updated too, otherwise we will
+	 * have a mistaken super block version in cache set.
+	 */
+	if (ca->sb.seq > c->sb.seq || c->sb.seq == 0) {
 		c->sb.version		= ca->sb.version;
 		memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
 		c->sb.flags             = ca->sb.flags;
-- 
2.25.1



