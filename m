Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11E34F0E7
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhC3STp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 14:19:45 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:29474 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhC3STN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 14:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617128353; x=1648664353;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=phPYfnaGn54jOaVBIywTvN7R+TmivCcJUjOtUPWOZ3A=;
  b=nAcIhVKIU8GTap3tSy9hoCR4gTvcOtvqU0EW9MtyQ1C562xb8yXxODjl
   s9mEgQM4LzbDFdHHDTwP4SIwd3cBxMCw4gJ7+nosZ6p+EzLJ50fFcjEJV
   CKdigilb7x3chVKdS6UxEpBxAqaI6xUQ4PpSuKeJmyYpxc59j/pZFvBUj
   I=;
X-IronPort-AV: E=Sophos;i="5.81,291,1610409600"; 
   d="scan'208";a="922494442"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 30 Mar 2021 18:19:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id CB004A193E
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 18:19:11 +0000 (UTC)
Received: from EX13D13UWB001.ant.amazon.com (10.43.161.156) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D13UWB001.ant.amazon.com (10.43.161.156) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:10 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 30 Mar 2021 18:19:10 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id DA2E4DF085; Tue, 30 Mar 2021 18:19:10 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 0/5] memcontrol follow-up patches
Date:   Tue, 30 Mar 2021 18:19:05 +0000
Message-ID: <20210330181910.15378-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the 4.14.214 timeframe, we submitted the following
cherry-picks/backports:

mm: memcontrol: eliminate raw access to stat and event counters
mm: memcontrol: implement lruvec stat functions on top of each other
mm: memcontrol: fix excessive complexity in memory.stat reporting

They were accepted and part of linux-4.14.y since 4.14.214.

These were valid fixes, but needed a few follow-ups, or regressions
could occur. The regressions are described in the follow-up commits.

This 4.14 series adds these follow-ups, fixing these regressions.

Apologies for missing these commits. Two of them even
had the proper Fixes tags. The other two didn't, but still
mentioned the original commit in the description, so we should
have caught them.

They are all clean cherry-picks, with the exception of
"mm: fix oom_kill event handling", which needed minor
contextual massaging.

----

Aaron Lu (1):
  mem_cgroup: make sure moving_account, move_lock_task and stat_cpu in
    the same cacheline

Greg Thelen (1):
  mm: writeback: use exact memcg dirty counts

Johannes Weiner (2):
  mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
  mm: memcg: make sure memory.events is uptodate when waking pollers

Roman Gushchin (1):
  mm: fix oom_kill event handling

 include/linux/memcontrol.h | 111 ++++++++++++++++++++++++++-----------
 mm/memcontrol.c            |  54 ++++++++++++------
 mm/oom_kill.c              |   2 +-
 mm/vmscan.c                |   2 +-
 4 files changed, 118 insertions(+), 51 deletions(-)
