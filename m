Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0F360D8E2
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 03:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiJZBlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 21:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiJZBlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 21:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43112A2A8B;
        Tue, 25 Oct 2022 18:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF17A61C50;
        Wed, 26 Oct 2022 01:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C66C433D6;
        Wed, 26 Oct 2022 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666748461;
        bh=HMpL6hS0x/pFA1yF5U8ZSD3vDP7j1U1jNCuYOWMr44U=;
        h=Date:To:From:Subject:From;
        b=NfdHp3ga63ZxnlUB/fLh8vvWMvsJTa8a69mM2gZ/8L0CJ4FuqZLNH1nfZmWNH9I+k
         obx+Sr+BltSYBpF9nz1ky5+mla1bANh1cUjGz5R9MuQ4BNL9lYKDUM2yBW3rRGKnR1
         dyF9SezoBM7BwxICc9RkqtDkXOIv7RvSv9o7x4is=
Date:   Tue, 25 Oct 2022 18:41:00 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, jlayton@kernel.org, jack@suse.cz,
        deepa.kernel@gmail.com, brauner@kernel.org, arnd@arndb.de,
        scdbackup@gmx.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] isofs-prevent-file-time-rollover-after-year-2038.patch removed from -mm tree
Message-Id: <20221026014101.41C66C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: isofs: prevent file time rollover after year 2038
has been removed from the -mm tree.  Its filename was
     isofs-prevent-file-time-rollover-after-year-2038.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Schmitt <scdbackup@gmx.net>
Subject: isofs: prevent file time rollover after year 2038
Date: Thu, 20 Oct 2022 18:00:29 +0200

Change the return type of function iso_date() from int to time64_t, to
avoid truncating to the 1902..2038 date range.

After this patch, the reported timestamps should fall into the range
reported in the s_time_min/s_time_max fields.

[arnd@arndb.de: expand changelog text slightly]
Link: https://lkml.kernel.org/r/20221020160037.4002270-1-arnd@kernel.org
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=800627
Fixes: 34be4dbf87fc ("isofs: fix timestamps beyond 2027")
Fixes: 5ad32b3acded ("isofs: Initialize filesystem timestamp ranges")
Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/isofs.h |    2 +-
 fs/isofs/util.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/isofs/isofs.h~isofs-prevent-file-time-rollover-after-year-2038
+++ a/fs/isofs/isofs.h
@@ -106,7 +106,7 @@ static inline unsigned int isonum_733(u8
 	/* Ignore bigendian datum due to broken mastering programs */
 	return get_unaligned_le32(p);
 }
-extern int iso_date(u8 *, int);
+extern time64_t iso_date(u8 *, int);
 
 struct inode;		/* To make gcc happy */
 
--- a/fs/isofs/util.c~isofs-prevent-file-time-rollover-after-year-2038
+++ a/fs/isofs/util.c
@@ -16,10 +16,10 @@
  * to GMT.  Thus  we should always be correct.
  */
 
-int iso_date(u8 *p, int flag)
+time64_t iso_date(u8 *p, int flag)
 {
 	int year, month, day, hour, minute, second, tz;
-	int crtime;
+	time64_t crtime;
 
 	year = p[0];
 	month = p[1];
_

Patches currently in -mm which might be from scdbackup@gmx.net are


