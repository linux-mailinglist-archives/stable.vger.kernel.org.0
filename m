Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA287672A99
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 22:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjARVfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 16:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjARVfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 16:35:17 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DD85D7FC
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 13:35:16 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id g10so86836qvo.6
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 13:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WFQ+oxRa/iIpUyO/Bpx78nE7emcpH/SQ9k0cki7noDw=;
        b=AMB3WEVF4CuGdpNZmRE4OxxGoVBatnviV6iC0kwVaFdMwZiTSq97zrzWgMJAnyYilO
         b5m//mxAtemZ75EadzpMd/IZOWTFJ5OBcqVXBpcYGgr58mVj1JIilLbQKPhAeGMX8MkS
         Xc0VDMKnaktQG4OhcrpQsKJuhlSv9Okt2McghA7i5Cb+z4L4C/fL1KEB7QYEdUF9fPaP
         Ik7XOrrtDiwNSHguwx7r3PBvhCUQU+MEx8NWOp3XvIizAUyVi9e6y+JmCyJjkxDKqrVq
         Dwcp6TEe6aOQ2sD46l1L76SGZ06p/8Bf9hZ4/gQ7x4MhvbY75zQEX0HViEChMKinsBUv
         DsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFQ+oxRa/iIpUyO/Bpx78nE7emcpH/SQ9k0cki7noDw=;
        b=GNJPFpJmeVPsS0yY+kyoolJCSJVOs0oRu2XlJUhaVfMZcSLOaOAB0a6azWiyv2YePa
         Lh/Pi/Q8qdhOGG0jNpOpmr7xfsdmkZshytEW3zx41fhpGEUlylaixibJe7/jAWuKCklc
         W26QKxGSl2KnLHDn8LM952htpjAFiPZz4ysYy4Bsnw5f21KGgsJBXePt72T1nCnZAdZm
         71t3pkKb5xG/M+X4mxpVsA6ocB39DzwxyTcZ4+9IhHicCuXNVPFoxUjNOTRDWwBuDFB5
         frOdSgomnowJdo9spNkCFmdLRq+TBgpWaoiX++q19jbTmhih4e/niNVjWSAeUFSzIsWu
         VSLg==
X-Gm-Message-State: AFqh2kqlWEgFhKr5ccHtofqNkdrB1ZQWf2ff0PCVe9pMfOgfi2vqhVln
        PZa01S/zsaCwMqCe0drDpP/qaA==
X-Google-Smtp-Source: AMrXdXt7qXJh5rVJ3N/kuPjocpbIP8D7F5BTA2hAwxp6RAWZb7wXQZYJOFfeSzkh6J1nXabl2mOLiw==
X-Received: by 2002:a05:6214:8c7:b0:532:2efb:fed1 with SMTP id da7-20020a05621408c700b005322efbfed1mr11211289qvb.46.1674077715096;
        Wed, 18 Jan 2023 13:35:15 -0800 (PST)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05620a319a00b00706a1551408sm3562676qkb.4.2023.01.18.13.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:35:14 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: limit device extents to the device size
Date:   Wed, 18 Jan 2023 16:35:13 -0500
Message-Id: <158f8775fb0256a09ab4badb752e2202aa118e1d.1674077707.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There was a recent regression in btrfs/177 that started happening with
the size class patches.  This however isn't a regression introduced by
those patches, but rather the bug was uncovered by a change in behavior
in these patches.  The patches triggered more chunk allocations in the
^free-space-tree case, which uncovered a race with device shrink.

The problem is we will set the device total size to the new size, and
use this to find a hole for a device extent.  However during shrink we
may have device extents allocated past this range, so we could
potentially find a hole in a range past our new shrink size.  We don't
actually limit our found extent to the device size anywhere, we assume
that we will not find a hole past our device size.  This isn't true with
shrink as we're relocating block groups and thus creating holes past the
device size.

Fix this by making sure we do not search past the new device size, and
if we wander into any device extents that start after our device size
simply break from the loop and use whatever hole we've already found.

cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 675598c3cb35..707dd0456cea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1600,7 +1600,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	if (ret < 0)
 		goto out;
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1623,6 +1623,9 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 			dev_extent_hole_check(device, &search_start, &hole_size,
@@ -1683,6 +1686,7 @@ static int find_free_dev_extent_start(struct btrfs_device *device,
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;
-- 
2.26.3

