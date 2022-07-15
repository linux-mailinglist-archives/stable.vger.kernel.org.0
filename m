Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775F5576A2A
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 00:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiGOWvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 18:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiGOWvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 18:51:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29724331E;
        Fri, 15 Jul 2022 15:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADA23B82EF0;
        Fri, 15 Jul 2022 22:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43707C3411E;
        Fri, 15 Jul 2022 22:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657925477;
        bh=o0ng7rDUX3HJX5PzVTuirQIgJKM/KMzDsM7dZaRh1UQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jN2p0VTKf1wUpI/xIITkZTZrE1Q/c7CqHuh8qboGE4G0SNvGc9IfTeBQLq2ahdIuY
         do2hayd/4Mmdbw5t7ZkJv8RDEvHCtnoaNR+ZQRxgkhfP63e+xVcp0HK1+dGzHK+Ezq
         SU0WLlUSv1HgX09NslYVXtXxn7idycRhZNlLaHkx+pQhPv2DjP/5iM1qPm5Wt49clu
         KSJFB+1yJ9ejUCFuXU6tGi7Iw+xJiJsJAwEWDq7XAOf5txN7DzZccNtqA5IcsLvr5E
         /Ouo0Gdk7SlwryUAz67KdbHlBT/dXn9pau8TVZIxon9PgFxpE4eJHTjPbFNjXOp1Mn
         Jtupck9KTLUQA==
From:   SeongJae Park <sj@kernel.org>
To:     roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, jgross@suse.com,
        olekstysh@gmail.com, andrii.chepurnyi82@gmail.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 0/3] xen-blk{back,front}: Fix two bugs in 'feature_persistent'
Date:   Fri, 15 Jul 2022 22:51:05 +0000
Message-Id: <20220715225108.193398-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Introduction of 'feature_persistent' made two bugs.  First one is wrong
overwrite of 'vbd->feature_gnt_persistent' in 'blkback' due to wrong
parameter value caching position, and the second one is unintended
behavioral change that could break previous dynamic frontend/backend
persistent feature support changes.  This patchset fixes the issues.

Changes from v3
(https://lore.kernel.org/xen-devel/20220715175521.126649-1-sj@kernel.org/)
- Split 'blkback' patch for each of the two issues
- Add 'Reported-by: Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>'

Changes from v2
(https://lore.kernel.org/xen-devel/20220714224410.51147-1-sj@kernel.org/)
- Keep the behavioral change of v1
- Update blkfront's counterpart to follow the changed behavior
- Update documents for the changed behavior

Changes from v1
(https://lore.kernel.org/xen-devel/20220106091013.126076-1-mheyne@amazon.de/)
- Avoid the behavioral change
  (https://lore.kernel.org/xen-devel/20220121102309.27802-1-sj@kernel.org/)
- Rebase on latest xen/tip/linux-next
- Re-work by SeongJae Park <sj@kernel.org>
- Cc stable@

Maximilian Heyne (1):
  xen-blkback: Apply 'feature_persistent' parameter when connect

SeongJae Park (2):
  xen-blkback: fix persistent grants negotiation
  xen-blkfront: Apply 'feature_persistent' parameter when connect

 .../ABI/testing/sysfs-driver-xen-blkback      |  2 +-
 .../ABI/testing/sysfs-driver-xen-blkfront     |  2 +-
 drivers/block/xen-blkback/xenbus.c            | 20 ++++++++-----------
 drivers/block/xen-blkfront.c                  |  4 +---
 4 files changed, 11 insertions(+), 17 deletions(-)

-- 
2.25.1

