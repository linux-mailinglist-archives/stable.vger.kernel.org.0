Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C734A56D
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 11:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCZKYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 06:24:16 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:43702 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhCZKYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 06:24:06 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 063324051F;
        Fri, 26 Mar 2021 10:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1616754245; bh=N4KEt8HGG20uNNGgCs8skksTbVHBkSJz3itIK2LJ8Nk=;
        h=Date:From:Subject:To:Cc:From;
        b=RaxD2xjM98oICRA6wGsDryoq+CwLUl9l52ySYTLP7JxFTJBqziLvrRCm0820kwIX8
         D6ybcANHScvZY59EijvXWJO70drm+tADVa9mY0wbHAslpGuxNDH8w/c11Mwu386hPs
         ZC6IHzs4/kpV9Py1CCOe/Ly8U7Kk9H/aiyhRu2a/0SuGrA0ubrkFc9I7r2tIhnTnHM
         eO4LOAnGVcIrmvX37aF/csF97P7OII1WL7H2xXXRq5EA0vvZ/T0yYnXC8IWoCAq8el
         orlucgKsmZn6d0Nwcbp/ZAqO0AHRrfmFWk/tBbvVR2BpIfOxl+1qXqPa6pKSw9tgmp
         RnAbEgooAqqjw==
Received: from razpc-HP (razpc-hp.internal.synopsys.com [10.116.126.207])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 359EFA005C;
        Fri, 26 Mar 2021 10:24:00 +0000 (UTC)
Received: by razpc-HP (sSMTP sendmail emulation); Fri, 26 Mar 2021 14:23:58 +0400
Date:   Fri, 26 Mar 2021 14:23:58 +0400
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Subject: [PATCH 0/3] usb: dwc2: Fix power saving general issues.
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, <stable@vger.kernel.org>,
        #@synopsys.com, 4.18@synopsys.com, <stable@vger.kernel.org>,
        #@synopsys.com, 5.2@synopsys.com, Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Message-Id: <20210326102400.359EFA005C@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch set is part of multiple series and is
continuation of the "usb: dwc2: Fix and improve
power saving modes" patch set.
(Patch set link: https://marc.info/?l=linux-usb&m=160379622403975&w=2).

The patches that were included in the "usb: dwc2:
Fix and improve power saving modes" which was submitted
earlier was too large and needed to be split up into
smaller patch sets. So this is the first series in the
whole power saving mode fixes.

Each remaining patch set have dependency on previous set
and will be submitted after each of them are integrated.

The series includes the following patch sets with multiple patches
by below order.
 1. usb: dwc2: Fix power saving general issues.
 2. usb: dwc2: Fix Partial Power down issues.
 3. usb: dwc2: Add clock gating support.
 4. usb: dwc2: Fix Hibernation issues

Changes since V1:
- Added Fixes tag and stable kernel in below patches to point to the commits the
  fixes are addressing
  1. "usb: dwc2: Prevent core suspend when port connection flag is 0"
  2. "usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board."
- Updated the changelog of "usb: dwc2: Add default param to control power optimization." patch. 


Artur Petrosyan (3):
  usb: dwc2: Add default param to control power optimization.
  usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.
  usb: dwc2: Prevent core suspend when port connection flag is 0

 drivers/usb/dwc2/core.h    |  3 +++
 drivers/usb/dwc2/debugfs.c |  2 ++
 drivers/usb/dwc2/hcd.c     |  5 +++--
 drivers/usb/dwc2/params.c  | 17 ++++++++++++-----
 4 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.25.1

