Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0572DD4D9
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 17:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgLQQFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 11:05:16 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:23689 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgLQQFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 11:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608221115; x=1639757115;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=IZTMRACT5Z0nH+RTJp7IYNQQKSOJfHOu4NGys+BUEro=;
  b=f/CBK/3JIY6qcpetJ+GREO851q5+qiWvyyZcaLCwpR4w7XG8p5OZ0ufo
   kRLA998VkMz0/Or7ZHiEq6eNaYcnp5XB77RuGxegsFa/Hc3pFNyT09LOU
   FdYCSGQk8SDOzH7QVQpbUAlOJ+26+tp4R5GcGMMSQi5W0ePwxA5KBfaF4
   8=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="903962096"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 17 Dec 2020 16:04:28 +0000
Received: from EX13D31EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id E872FA2226;
        Thu, 17 Dec 2020 16:04:27 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.146) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 16:04:21 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <stable@vger.kernel.org>
CC:     SeongJae Park <sjpark@amazon.de>, <doebel@amazon.de>,
        <aams@amazon.de>, <mku@amazon.de>, <jgross@suse.com>,
        <julien@xen.org>, <wipawel@amazon.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/5] Backport of patch series for stable 4.4 branch
Date:   Thu, 17 Dec 2020 17:03:57 +0100
Message-ID: <20201217160402.26303-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D14UWC001.ant.amazon.com (10.43.162.5) To
 EX13D31EUA004.ant.amazon.com (10.43.165.161)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Changes from v2
(https://lore.kernel.org/stable/20201217130501.12702-1-sjpark@amazon.com/)
- Move 'nr_pending' increase from 5th patch to 4th patch

Changes from v1
(https://lore.kernel.org/stable/20201217081727.8253-1-sjpark@amazon.com/)
- Remove wrong 'Signed-off-by' lines for 'Author Redacted'


SeongJae Park (5):
  xen/xenbus: Allow watches discard events before queueing
  xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
  xen/xenbus/xen_bus_type: Support will_handle watch callback
  xen/xenbus: Count pending messages for each watch
  xenbus/xenbus_backend: Disallow pending watch messages

 drivers/block/xen-blkback/xenbus.c        |  3 +-
 drivers/net/xen-netback/xenbus.c          |  4 ++-
 drivers/xen/xen-pciback/xenbus.c          |  2 +-
 drivers/xen/xenbus/xenbus_client.c        |  8 ++++-
 drivers/xen/xenbus/xenbus_probe.c         |  1 +
 drivers/xen/xenbus/xenbus_probe.h         |  2 ++
 drivers/xen/xenbus/xenbus_probe_backend.c |  7 +++++
 drivers/xen/xenbus/xenbus_xs.c            | 38 +++++++++++++++--------
 include/xen/xenbus.h                      | 15 ++++++++-
 9 files changed, 62 insertions(+), 18 deletions(-)

-- 
2.17.1

