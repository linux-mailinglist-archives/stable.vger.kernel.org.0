Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7702123E5FE
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 04:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgHGCqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 22:46:20 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:58158 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgHGCqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 22:46:20 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 035ABC0C28;
        Fri,  7 Aug 2020 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596768379; bh=FodOKO/g8YH4PwmZdpD6kU2JFjh3IhTHqi745xkO60Q=;
        h=Date:From:Subject:To:Cc:From;
        b=GUy+nwXEU1hvc3nrUsO3CaKKTW+QAxbm25nDk6A4cgy+r827bz8+Whn5WdRzA0hFr
         3IyaHKvNcwfmv3uPGj7oFkRFTRNMb3Ue7Vx7TPrPO2AFHDMYjf6MZRsgq/tPRX1fTy
         p9sLyrzZHeGcB2bYbCa8MBNMNu5p6VctRwwt8H/LlltkA+bCAuijns1DmT3ar9kJFk
         aUm7XP0M1/clMmU4a5Ck9Lfhakv1+6e/FJr8XG4FrJxhkDRkqrrelfHfcYVrhnYxjQ
         N4oCVJSQuBR+kkzN4vXggv4KWqb4HUjteSNCLA/FrJ7nfdJKJeguejcSaCaQlCsHly
         npeB3I2PrEEzw==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id F32E5A0096;
        Fri,  7 Aug 2020 02:46:16 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 06 Aug 2020 19:46:16 -0700
Date:   Thu, 06 Aug 2020 19:46:16 -0700
Message-Id: <cover.1596767991.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 0/7] usb: dwc3: gadget: Fix TRB preparation
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are a few issues in DWC3 driver when preparing for TRB.
The driver needs to account the following:

* MPS alignment for ZLP OUT direction
* Extra TRBs when checking for available TRBs
* SG entries size > request length

Along with these fixes, there are some cleanup/refactoring patches in this
series.

Changes in v2:
- Update remaining length when resume request
- Remove unused variables
- Add a missing "return 0" for dwc3_prepare_trbs()
- Update doc indicating dwc3_prepare_trbs() can return other -errno


Thinh Nguyen (7):
  usb: dwc3: gadget: Don't setup more than requested
  usb: dwc3: gadget: Fix handling ZLP
  usb: dwc3: gadget: Handle ZLP for sg requests
  usb: dwc3: gadget: Refactor preparing TRBs
  usb: dwc3: gadget: Account for extra TRB
  usb: dwc3: gadget: Rename misleading function names
  usb: dwc3: ep0: Skip ZLP setup for OUT

 drivers/usb/dwc3/ep0.c    |   2 +-
 drivers/usb/dwc3/gadget.c | 247 +++++++++++++++++++++++---------------
 2 files changed, 148 insertions(+), 101 deletions(-)


base-commit: e3ee0e740c3887d2293e8d54a8707218d70d86ca
-- 
2.28.0

