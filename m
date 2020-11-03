Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED00E2A3F18
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKCIlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:41:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:51030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCIlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 03:41:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604392910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=poIrhG/bpgIn4Tu/sW9oBxOf3k1RFScmFfbj+KTPfWo=;
        b=WVXAGRZC7veoDFLY1I4/Fj1peREi0647Oeebq0O3RAm9gs+OxCQuYmzrr1l6PryPNwUx/O
        Xf4fVXmDSHFqzZa6h+SNTUUzsRELHf/0ciiJuSe/1AdOcI0Mh2t0YkttxdU8MwWp73p2ej
        NEA9CCWlSDqYuMFzfg9IjRJrtwrygaA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B3BFFAD66
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:41:50 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 00/13] Backport of patch series for stable 4.9 branch
Date:   Tue,  3 Nov 2020 09:41:37 +0100
Message-Id: <20201103084150.8625-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Juergen Gross (13):
  xen/events: don't use chip_data for legacy IRQs
  xen/events: avoid removing an event channel while handling it
  xen/events: add a proper barrier to 2-level uevent unmasking
  xen/events: fix race in evtchn_fifo_unmask()
  xen/events: add a new "late EOI" evtchn framework
  xen/blkback: use lateeoi irq binding
  xen/netback: use lateeoi irq binding
  xen/scsiback: use lateeoi irq binding
  xen/pciback: use lateeoi irq binding
  xen/events: switch user event channels to lateeoi model
  xen/events: use a common cpu hotplug hook for event channels
  xen/events: defer eoi in case of excessive number of events
  xen/events: block rogue events for some time

 Documentation/kernel-parameters.txt   |   8 +
 drivers/block/xen-blkback/blkback.c   |  22 +-
 drivers/block/xen-blkback/xenbus.c    |   5 +-
 drivers/net/xen-netback/common.h      |  15 +
 drivers/net/xen-netback/interface.c   |  61 +++-
 drivers/net/xen-netback/netback.c     |  11 +-
 drivers/net/xen-netback/rx.c          |  13 +-
 drivers/xen/events/events_2l.c        |   9 +-
 drivers/xen/events/events_base.c      | 451 ++++++++++++++++++++++++--
 drivers/xen/events/events_fifo.c      |  82 +++--
 drivers/xen/events/events_internal.h  |  20 +-
 drivers/xen/evtchn.c                  |   7 +-
 drivers/xen/xen-pciback/pci_stub.c    |  14 +-
 drivers/xen/xen-pciback/pciback.h     |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c |  48 ++-
 drivers/xen/xen-pciback/xenbus.c      |   2 +-
 drivers/xen/xen-scsiback.c            |  23 +-
 include/xen/events.h                  |  29 +-
 18 files changed, 685 insertions(+), 147 deletions(-)

-- 
2.26.2

