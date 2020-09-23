Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51792274F49
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 04:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIWCzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 22:55:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:38328 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIWCzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 22:55:33 -0400
IronPort-SDR: 9hzGPT7qAaKNGRtmISTNskUVA9MKbQJftGdqcoxV7kuuHjRJv9QPdHaTUryvfa/QINOBhN3X1L
 q1VNjMH9n6kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="245600242"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245600242"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 19:55:32 -0700
IronPort-SDR: ATcuDmItjs5IlmRGQfhstLes0UiyOeSDq3zg9EWAyOMbRhxh3C9wFefp8yOjWs03Z1gOtwaQzr
 NYTGgIZ4gqNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="305190736"
Received: from unknown (HELO nodlab-S2600WFT.lm.intel.com) ([10.232.116.103])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2020 19:55:32 -0700
From:   Revanth Rajashekar <revanth.rajashekar@intel.com>
To:     stable@vger.kernel.org
Cc:     hch@lst.de, kbusch@kernel.org, damien.lemoal@wdc.com,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 0/3] [backport] nvme: Consolidate chunk_sectors settings
Date:   Tue, 22 Sep 2020 20:58:05 -0600
Message-Id: <20200923025808.14698-1-revanth.rajashekar@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport commit 38adf94e166e3cb4eb89683458ca578051e8218d and it's
dependencies to linux-stable 5.4.y.

Dependent commits:
314d48dd224897e35ddcaf5a1d7d133b5adddeb7
e08f2ae850929d40e66268ee47e443e7ea56eeb7

When running test cases to stress NVMe device, a race condition / deadlocks is
seen every couple of days or so where multiple threads are trying to acquire
ctrl->subsystem->lock or ctrl->scan_lock.

The test cases send a lot nvme-cli requests to do Sanitize, Format, FW Download,
FW Activate, Flush, Get Log, Identify, and reset requests to two controllers
that share a namespace. Some of those commands target a namespace, some target
a controller.  The commands are sent in random order and random mix to the two
controllers.

The test cases does not wait for nvme-cli requests to finish before sending more.
So for example, there could be multiple reset requests, multiple format requests,
outstanding at the same time as a sanitize, on both paths at the same time, etc.
Many of these test cases include combos that don't really make sense in the
context of NVMe, however it is used to create as much stress as possible.

This patchset fixes this issue.

Similar issue with a detailed call trace/log was discussed in the LKML
Link: https://lore.kernel.org/linux-nvme/04580CD6-7652-459D-ABDD-732947B4A6DF@javigon.com/

Revanth Rajashekar (3):
  nvme: Cleanup and rename nvme_block_nr()
  nvme: Introduce nvme_lba_to_sect()
  nvme: consolidate chunk_sectors settings

 drivers/nvme/host/core.c | 40 +++++++++++++++++++---------------------
 drivers/nvme/host/nvme.h | 16 +++++++++++++---
 2 files changed, 32 insertions(+), 24 deletions(-)

--
2.17.1

