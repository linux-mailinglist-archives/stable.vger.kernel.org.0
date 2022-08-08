Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E1758BECE
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbiHHBct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241932AbiHHBcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:16 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DC4B863;
        Sun,  7 Aug 2022 18:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659922335; x=1691458335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=INiQ8Xc6vYmw4rVgpY2wdX6BSH6zhrKKtsn8eP5KVSg=;
  b=K7ERqYyZ/NAT0s50zuqijAa9/EjbgguDPOCUPw+/cWqS8Rfzc0K5OGnd
   D1RzepZx6Ad1JOWp+Lu4XBJvgZ8efuAFPYNCRs09GHEZN9oeIj6SSwg9k
   boxCMGSw0NYAWczFbHcvWndAxrkENpqWK+FOXiwIxHyCmPkNVwFXyWnb+
   v6D0TP6ph2wmkd1EFDI0cppRSpz/U0KyJcGlBHSXP3GiATDzU8vyQGCh6
   udjeWOzn+lNceOodEVGunbuakETDjhjK/BKqyyn1Tio6Nzi7Rgvj+c6AQ
   Kt1T+uyhAxDgawCFxhNuI3zcXf+9XARvoY2AhtnfNuIqQCbVX8ob/ptp1
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320180302"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 09:32:14 +0800
IronPort-SDR: svhKq95YTcCVO1IyMOENWg3vPAVmb0TIShJ1U4/yjeSienvO/Cd8GH4OFtMNyi+oujGuZpNB8B
 UAiYMJe4JWam4ic3umXn8pvNkL7BSb8TtOgfVs0KLhJlAJyGTh/Q1ZlPS83ibLPvfWsVrJfSJ7
 vN0MZ4tkI5pJF5RPgrbPWeDmu4DIvxtX1YxBj5ToH21lwNDw6sWdB/yHlbgVRhCBiE96VaQ8Hn
 UKXRli4be1+8X+oGEl2hNYCv8A4fmRFTh4UCxjZNeuRCZjg4cqp6EMKOt866+Lskn1wBT06lFY
 /9LB9fm2yIZYh0sWnfCZ/Fwa
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 17:47:54 -0700
IronPort-SDR: kMf3RHnJQ8COOr/pZwxDq3Ot/v0/1HZyKcsVP7qXShg3qgC8EVEs9cOW52GzNxANDd7eqX/Esd
 TKE14loFOlw0jwnO/dFnsBvgcjtUhbVqOKzT5aXD/zYTyNPxnPIGlk1PlyARXkfwCAwTuKcnQ+
 GItqo5Wv2/SEw/y3s1cRDOXsgLQC2LaYgcydembZp2+k6k1laXIOrhdgE/KM++I1lS1EEFeH3N
 PliLLo7So2TEjW8lxzFrfUDqdrBAOCsXS0ARLuFB2YlJLR0r69n5JoAwmE867ScDljKwtn3hZK
 mhg=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Aug 2022 18:32:13 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH STABLE 5.18 0/3] btrfs: backport zoned mode fixes
Date:   Mon,  8 Aug 2022 10:32:07 +0900
Message-Id: <20220808013210.646680-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches are backport for the 5.18 branch.

They all fixes zoned mode related issued on btrfs.

The patch 3 looks different from upstream commit b3a3b0255797 ("btrfs:
zoned: drop optimization of zone finish") as a refactoring patch is not
picked into the stable branch. But, essentially, they do the same thing
which always zone finish the zones after (nearly) full write.

Naohiro Aota (3):
  btrfs: zoned: prevent allocation from previous data relocation BG
  btrfs: zoned: fix critical section of relocation inode writeback
  btrfs: zoned: drop optimization of zone finish

 fs/btrfs/block-group.h |  1 +
 fs/btrfs/extent-tree.c | 20 +++++++++++++++--
 fs/btrfs/extent_io.c   |  3 ++-
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/zoned.c       | 49 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/zoned.h       |  5 +++++
 6 files changed, 72 insertions(+), 8 deletions(-)

-- 
2.35.1

