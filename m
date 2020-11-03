Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D43B2A4B21
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgKCQWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:22:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:58664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgKCQWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 11:22:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604420559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FwLD1CQKWyXnwFsZhxK4sBkZ6XkIf8lEbSLUXy5M8Kg=;
        b=THloMdqOFKViWQdXAWzAmDk7b61+HrrALfCFJmSzK/BV5f5yEryTdLcIhCLPyS7LeeH8w5
        6oidBHvU09vEA3CRDKjYJQwthnitK513G4V/mynnISCTrWELcWSVV7oF42q0LwnvoWlF5I
        e1pYGEeBXgC19xE2dOw+mhArKVyjgyU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59C3BAD1E
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 16:22:39 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     stable@vger.kernel.org
Subject: [PATCH 00/13] Backport of patch series for stable 4.4 branch
Date:   Tue,  3 Nov 2020 17:22:25 +0100
Message-Id: <20201103162238.30264-1-jgross@suse.com>
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
 drivers/net/xen-netback/common.h      |  39 +++
 drivers/net/xen-netback/interface.c   |  59 +++-
 drivers/net/xen-netback/netback.c     |  17 +-
 drivers/xen/events/events_2l.c        |   9 +-
 drivers/xen/events/events_base.c      | 473 ++++++++++++++++++++++++--
 drivers/xen/events/events_fifo.c      | 102 +++---
 drivers/xen/events/events_internal.h  |  20 +-
 drivers/xen/evtchn.c                  |   7 +-
 drivers/xen/xen-pciback/pci_stub.c    |  14 +-
 drivers/xen/xen-pciback/pciback.h     |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c |  48 ++-
 drivers/xen/xen-pciback/xenbus.c      |   2 +-
 drivers/xen/xen-scsiback.c            |  23 +-
 include/xen/events.h                  |  29 +-
 17 files changed, 729 insertions(+), 160 deletions(-)

-- 
2.26.2

