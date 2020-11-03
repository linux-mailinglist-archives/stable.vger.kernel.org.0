Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB072A47C5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgKCOPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:15:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:55998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729647AbgKCONX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 09:13:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604412801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wKQaoasTQ5d9RftqDhAHXeOwYJGfnkI/PGhH6/KGvi0=;
        b=g2DgEW1PE6i5chG1+oZGdFqBhb0gznywHobNxxhyIj9HDMMFS73xQSRp2M+nMxvirPpmKF
        RpN7hHlXXWmp+VZohjG3r9wJpTti/GcEFgyGv+dz1iNtJEowbGuvqgjjFl6VRwnyxtzeSC
        610zNvyPXUNR60YF9hg4xnvF6or8gfk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8B71BABF4
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 14:13:21 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH v2 00/13] Backport of patch series for stable 5.4 branch
Date:   Tue,  3 Nov 2020 15:13:08 +0100
Message-Id: <20201103141321.20346-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V2: correct first patch

Juergen Gross (13):
  xen/events: avoid removing an event channel while handling it
  xen/events: add a proper barrier to 2-level uevent unmasking
  xen/events: fix race in evtchn_fifo_unmask()
  xen/events: add a new "late EOI" evtchn framework
  xen/blkback: use lateeoi irq binding
  xen/netback: use lateeoi irq binding
  xen/scsiback: use lateeoi irq binding
  xen/pvcallsback: use lateeoi irq binding
  xen/pciback: use lateeoi irq binding
  xen/events: switch user event channels to lateeoi model
  xen/events: use a common cpu hotplug hook for event channels
  xen/events: defer eoi in case of excessive number of events
  xen/events: block rogue events for some time

 .../admin-guide/kernel-parameters.txt         |   8 +
 drivers/block/xen-blkback/blkback.c           |  22 +-
 drivers/block/xen-blkback/xenbus.c            |   5 +-
 drivers/net/xen-netback/common.h              |  15 +
 drivers/net/xen-netback/interface.c           |  61 ++-
 drivers/net/xen-netback/netback.c             |  11 +-
 drivers/net/xen-netback/rx.c                  |  13 +-
 drivers/xen/events/events_2l.c                |   9 +-
 drivers/xen/events/events_base.c              | 422 ++++++++++++++++--
 drivers/xen/events/events_fifo.c              |  83 ++--
 drivers/xen/events/events_internal.h          |  20 +-
 drivers/xen/evtchn.c                          |   7 +-
 drivers/xen/pvcalls-back.c                    |  76 ++--
 drivers/xen/xen-pciback/pci_stub.c            |  14 +-
 drivers/xen/xen-pciback/pciback.h             |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c         |  48 +-
 drivers/xen/xen-pciback/xenbus.c              |   2 +-
 drivers/xen/xen-scsiback.c                    |  23 +-
 include/xen/events.h                          |  29 +-
 19 files changed, 710 insertions(+), 170 deletions(-)

-- 
2.26.2

