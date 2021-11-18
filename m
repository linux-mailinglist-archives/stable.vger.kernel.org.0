Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100BE45577E
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbhKRJBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:36 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58233 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244895AbhKRJB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225909; x=1668761909;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z4FaRnAXxCpviW3a1WBY3pRpCfXcdlVDqxdukww39Ww=;
  b=iSFJ8w5CnmmKlFGj0Ilua5PlNWZnB8IdwOgHGSS+kqpumGSAuUFQ+T7l
   kuOPEka3esuJOeHZY9XkDgoHEu7VQve8HaJmf6gygq7HvbSxRFR9I1vth
   t4EF3B+Bl7IiePCIMO6z6kzWnBU2U7xaRtRtENxbYhGlBmTHcXQsm1a30
   sWiQ0acTMhDgJxsEW+dM6oO6BXFUcFQpMzYmu904ObJWqJSgnsC6bynu3
   DUNBL7SlCQTCWLQXGlMR35FWU53l4FmrDt3UUXKkvXu0gSnYfs+2Sdz8e
   CSkbMnoxyGThI3n+xKsoKFMoCa9bGT0XQgJuOTnA8W7AYChcUQv/LtlUN
   g==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="297759012"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:26 +0800
IronPort-SDR: jktKiPDRWzeBU3OJkxA5WzeBBwLgGiTiboIBgVYUEt8nEygTmXTmhgi0KG303nsyNfzkKbtVuV
 JgueYL7ypfNsVRo9FzqRzck86YzAwgs1qodc2cqhBIGA1SdtMlZVwE+PGmYJwxpKbrh8IeBmqK
 FcuDGLPk7mmqupiIVJJsJdlpHdt76NgC+epZ3xo312777sqZOEiO7XbnSRDennqqcWKTQqXpMG
 5tgY1o5Ghxop8r8DbioNnVRqN6sq/3tMhmBgtyid6R7LicxLR7qM5PUYfLNu+PaQzPb+3JYFFA
 At0wyRqb3vNua0xgHRhRVZvs
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:26 -0800
IronPort-SDR: 3RJ7hrLylJT2FWe/gVPgfVo32mD4DFHwPRcW2wzk9tiCjpypXSPiT0n4rEPKPZpId0qzvRh5lz
 kEAaO6UCCeg3D6ew7Zc4GEKzjk03GwAuoLD6P5QUuk1JbYVH+I+2mtXf5YLuWmb0xo4p+NGeRq
 pD96bGl0mMZGgrgZUoW3JMLiwfcw+hs7esN3NifUJP8ZK0VWEyt4pEmGhY2dWGijC/YTAK9hI6
 nfTYc758sswqMseauvOWhqkar4L3TAPP3akSpgsQQl3BYlf2mP12AAHlNXzOQyDT45lmWOoVoM
 bBg=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:24 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 0/6] btrfs: zoned: backport of 5.16 relocation fixes
Date:   Thu, 18 Nov 2021 17:58:12 +0900
Message-Id: <cover.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and stable team,

Here's a backport of relocation fixes that went into 5.16 aimed at the 5.15.x
series of stable kernels. It's a problem people are currently running into
when using btrfs on a zoned block device.

The following patches have been backported:
960a3166aed0 ("btrfs: zoned: allow preallocation for relocation inodes")
2adada886b26 ("btrfs: check for relocation inodes on zoned btrfs in should_nocow")
e6d261e3b1f7 ("btrfs: zoned: use regular writes for relocation")
35156d852762 ("btrfs: zoned: only allow one process to add pages to a relocation inode")
c2707a255623 ("btrfs: zoned: add a dedicated data relocation block group")
37f00a6d2e9c ("btrfs: introduce btrfs_is_data_reloc_root")

The backport has seen the usual regression testing with xfstests.

Johannes Thumshirn (6):
  btrfs: introduce btrfs_is_data_reloc_root
  btrfs: zoned: add a dedicated data relocation block group
  btrfs: zoned: only allow one process to add pages to a relocation
    inode
  btrfs: zoned: use regular writes for relocation
  btrfs: check for relocation inodes on zoned btrfs in should_nocow
  btrfs: zoned: allow preallocation for relocation inodes

 fs/btrfs/block-group.c |  1 +
 fs/btrfs/ctree.h       | 12 +++++++++
 fs/btrfs/disk-io.c     |  3 ++-
 fs/btrfs/extent-tree.c | 56 +++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/extent_io.c   | 11 +++++++++
 fs/btrfs/inode.c       | 29 +++++++++++++---------
 fs/btrfs/relocation.c  | 38 +++-------------------------
 fs/btrfs/zoned.c       | 21 ++++++++++++++++
 fs/btrfs/zoned.h       |  3 +++
 9 files changed, 123 insertions(+), 51 deletions(-)

-- 
2.32.0

