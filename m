Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F657356899
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350446AbhDGKAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:00:32 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:39484 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhDGKAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 06:00:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5676F404A0;
        Wed,  7 Apr 2021 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617789623; bh=5j9+LN48/eUhsAf/2HaDqriIe19NdgXnp/wRV+fh3Gw=;
        h=Date:From:Subject:To:Cc:From;
        b=YHbwi9Qp0mX9OTmwC77DbcxOU3ruwdLD91CD9DI35TxoGdNOYhOlT6BCmHdEVIryo
         QH+9Zd1UBg6qShrnjZ86r8ZYqo0RhYhNdO1uDvCcPgi/s4YKtVFA2nJE2uuyEE6LUe
         +kt1OyITs/NXvTjpcTAiiZljTSnR4ID/82YcaB9ggw4JlNlW5LyRsQzg6+QzI7Wh0p
         wIP2FabU0CYaeoffGMbQX6F/fNJvXiY/8MlLvcragOoYziBghmp5hxbei5y7QR5PJl
         YjsiMTllwtt8Lir84Mg8bJM5E+/lQoLOZgkk96zhmTuMk9uu0IkE9EqDPAT7nyeREO
         Yj9nPJcdYIuMw==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 4441BA0094;
        Wed,  7 Apr 2021 10:00:17 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Wed, 07 Apr 2021 14:00:15 +0400
Date:   Wed, 07 Apr 2021 14:00:15 +0400
Message-Id: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 00/14] usb: dwc2: Fix Partial Power down issues.
To:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>,
        Douglas Anderson <dianders@chromium.org>
Cc:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, <stable@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kever Yang <kever.yang@rock-chips.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch set fixes and improves the Partial Power Down mode for
dwc2 core.
It adds support for the following cases
    1. Entering and exiting partial power down when a port is
       suspended, resumed, port reset is asserted.
    2. Exiting the partial power down mode before removing driver.
    3. Exiting partial power down in wakeup detected interrupt handler.
    4. Exiting from partial power down mode when connector ID.
       status changes to "connId B

It updates and fixes the implementation of dwc2 entering and
exiting partial power down mode when the system (PC) is suspended.

The patch set also improves the implementation of function handlers
for entering and exiting host or device partial power down.

NOTE: This is the second patch set in the power saving mode fixes
series.
This patch set is part of multiple series and is continuation
of the "usb: dwc2: Fix and improve power saving modes" patch set.
(Patch set link: https://marc.info/?l=linux-usb&m=160379622403975&w=2).
The patches that were included in the "usb: dwc2:
Fix and improve power saving modes" which was submitted
earlier was too large and needed to be split up into
smaller patch sets. 


Artur Petrosyan (14):
  usb: dwc2: Add device partial power down functions
  usb: dwc2: Add host partial power down functions
  usb: dwc2: Update enter and exit partial power down functions
  usb: dwc2: Add partial power down exit flow in wakeup intr.
  usb: dwc2: Update port suspend/resume function definitions.
  usb: dwc2: Add enter partial power down when port is suspended
  usb: dwc2: Add exit partial power down when port is resumed
  usb: dwc2: Add exit partial power down when port reset is asserted
  usb: dwc2: Add part. power down exit from
    dwc2_conn_id_status_change().
  usb: dwc2: Allow exit partial power down in urb enqueue
  usb: dwc2: Fix session request interrupt handler
  usb: dwc2: Update partial power down entering by system suspend
  usb: dwc2: Fix partial power down exiting by system resume
  usb: dwc2: Add exit partial power down before removing driver

 drivers/usb/dwc2/core.c      | 113 ++-------
 drivers/usb/dwc2/core.h      |  27 ++-
 drivers/usb/dwc2/core_intr.c |  46 ++--
 drivers/usb/dwc2/gadget.c    | 148 ++++++++++-
 drivers/usb/dwc2/hcd.c       | 458 +++++++++++++++++++++++++----------
 drivers/usb/dwc2/hw.h        |   1 +
 drivers/usb/dwc2/platform.c  |  11 +-
 7 files changed, 558 insertions(+), 246 deletions(-)


base-commit: e9fcb07704fcef6fa6d0333fd2b3a62442eaf45b
-- 
2.25.1

