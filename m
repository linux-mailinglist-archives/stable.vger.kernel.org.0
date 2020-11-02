Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114C02A2A83
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgKBMRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:17:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:48042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbgKBMRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 07:17:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604319443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dakO2eqDs+/xkLYA+D9CLHPRQ6hVFsHULOnfX6ANSSo=;
        b=BC63f72/2Yh3qYGL/piGdc6jO7ltp4MHSD4lFHV1BFqY1FmOiCF1Rujnrde/XU/zDc8vda
        bgqcb9IfkftJpEWCj7TPeg80KMnscc6oc3jRNht9LKcpXuGaQMdi8iFa+hztVLuEoFelwc
        FyCGzaU5seamURrqYxUemub4qlUYFhs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F9E6AD7C
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 12:17:23 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 00/14] Backport of patch series for stable 4.19 branch
Date:   Mon,  2 Nov 2020 13:17:08 +0100
Message-Id: <20201102121722.10940-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Juergen Gross (14):
  xen/events: don't use chip_data for legacy IRQs
  xen/events: avoid removing an event channel while  handling it
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
 drivers/xen/events/events_base.c              | 451 ++++++++++++++++--
 drivers/xen/events/events_fifo.c              |  83 ++--
 drivers/xen/events/events_internal.h          |  20 +-
 drivers/xen/evtchn.c                          |   7 +-
 drivers/xen/pvcalls-back.c                    |  76 +--
 drivers/xen/xen-pciback/pci_stub.c            |  14 +-
 drivers/xen/xen-pciback/pciback.h             |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c         |  48 +-
 drivers/xen/xen-pciback/xenbus.c              |   2 +-
 drivers/xen/xen-scsiback.c                    |  23 +-
 include/xen/events.h                          |  29 +-
 19 files changed, 731 insertions(+), 178 deletions(-)

-- 
2.26.2

