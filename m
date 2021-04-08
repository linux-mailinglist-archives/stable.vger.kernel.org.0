Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67B6357D53
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 09:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhDHH2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 03:28:43 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:59968 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhDHH2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 03:28:41 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 400F640556;
        Thu,  8 Apr 2021 07:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617866911; bh=MayTwbhgx5n8GaJ/Kha7XYbeB6XviL3Z8jfc1aJZQRQ=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=GT4eAEcDxrVoJRaN+l35ES5wNXBCIpX2GLONMcy5VFTeMeN02GeZffu8I29qYPZU/
         1QlM/jSiPK36z7hL4E8nL8yCxxJKpMdXowC3MBGweYBonscPEwhhjzsUQTglrcUl5d
         +0pA7YP7Wxua15xObS8AXUOYKn7xlvkBiuRs4v2F6FYcITNKApGrZje+CvHgs8SPpW
         Tf+6BkKH6G64brSDplDOzDCpVouIB5yYNNwwGFAFHyOpSzaq0IzRuR3Ct32r3ezFiZ
         Yg7FRSVN1KX/036LguP4LBaDgxPAujzDS7THqbSXZBQwNhM/zOKfzmj9xNwG4FkyFH
         bfi5KsPTo7kBg==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 61347A022E;
        Thu,  8 Apr 2021 07:28:25 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Thu, 08 Apr 2021 11:28:24 +0400
Date:   Thu, 08 Apr 2021 11:28:24 +0400
In-Reply-To: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
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
Message-Id: <20210408072825.61347A022E@mailhost.synopsys.com>
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

Changes since V1:
No changes in the patches or the source code.
Sending the second version of the patch set because the first version
was not received by vger.kernel.org.



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

