Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5057666C
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 19:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGORz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 13:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiGORzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 13:55:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15D3AE65;
        Fri, 15 Jul 2022 10:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEDD3B82D63;
        Fri, 15 Jul 2022 17:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A0BC34115;
        Fri, 15 Jul 2022 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657907752;
        bh=3vpFnLXaDApO/bt2hcR2Da04h1fv9AjDwAOX2idNzpY=;
        h=From:To:Cc:Subject:Date:From;
        b=Q/ZTXqmNHNmAWAhqO90vFwqEL5aIVTYf+ebtpezt8GgJHQN+wfnpq6cNk4/7kFaX9
         ufxmW2Sui2gMueP9cdN3WEXzj6fDf0gjv5bqwHPH+qh11iDvKKcH+72aEa281diUlo
         xWFSSFsseYO6Pbbb7XKx4WeL5FIiTSUe5CtPTIttcnKrk1ajgtYis34qYUmSFiPfva
         akRFGTDdtn7ZxgJg8oFbhSi0hv3ZkVcCcLqjYp4QtcmQYrYm8ZLVjb1k+v9Zbh+3U2
         LtEeW8KscRSshrNMDjKjANF5k96gJWHR4IpuJwZbTrNXHp+gC9qYY6gAJBF3Vf8jpA
         wqakYDG7mRLqg==
From:   SeongJae Park <sj@kernel.org>
To:     roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, jgross@suse.com,
        olekstysh@gmail.com, andrii.chepurnyi82@gmail.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 0/2] Fix persistent grants negotiation with a behavior change
Date:   Fri, 15 Jul 2022 17:55:19 +0000
Message-Id: <20220715175521.126649-1-sj@kernel.org>
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

The first patch of this patchset fixes 'feature_persistent' parameter
handling in 'blkback' to respect the frontend's persistent grants
support always.  The fix makes a behavioral change, so the second patch
makes the counterpart of 'blkfront' to consistently follow the behavior
change.

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
  xen, blkback: fix persistent grants negotiation

SeongJae Park (1):
  xen-blkfront: Apply 'feature_persistent' parameter when connect

 Documentation/ABI/testing/sysfs-driver-xen-blkback  | 2 +-
 Documentation/ABI/testing/sysfs-driver-xen-blkfront | 2 +-
 drivers/block/xen-blkback/xenbus.c                  | 9 +++------
 drivers/block/xen-blkfront.c                        | 4 +---
 4 files changed, 6 insertions(+), 11 deletions(-)

-- 
2.25.1

