Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260C23D4CC
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHFAos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:44:48 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59024 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgHFAor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:44:47 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E42F5C0BBD;
        Thu,  6 Aug 2020 00:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596674686; bh=1c/MFJts3h/Olny4+yRENzVMH46l/md2vN+CQJYSKqU=;
        h=Date:From:Subject:To:Cc:From;
        b=F004Co/jP8u71YCwchAeP7FYSuDbcGCezXA8kFkI6MLfp3no6uStDYrBgPo8ONy1q
         PpA9cErETFlza6mIbL8NCY5cKKuAss8KFidU4itIoWCYqSSYqlk5Iu9MSnYylv9EzQ
         cDDb/jeAJWWu/HH9eIljFCeZv7GHN3hvvYKexjLUzDVO+SBdR6iyuziRBi/hRiJtKn
         KueKATq806/w7hsZSKfw1ykRhWQUoc+qQde1wa1RGOJwKUS4sbYFr4Kff1rjtcYGG0
         i8q93gP71QgolcGfSmOoNA2yer/GjHJmMxCaiD+PpPsE1vFzvMGNKjGHiCmUWfrvRu
         oQoqlN+XCwLcQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 44550A006F;
        Thu,  6 Aug 2020 00:44:44 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 05 Aug 2020 17:44:43 -0700
Date:   Wed, 05 Aug 2020 17:44:43 -0700
Message-Id: <cover.1596674377.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/7] usb: dwc3: gadget: Fix TRB preparation
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
series .


Thinh Nguyen (7):
  usb: dwc3: gadget: Don't setup more than requested
  usb: dwc3: gadget: Fix handling ZLP
  usb: dwc3: gadget: Handle ZLP for sg requests
  usb: dwc3: gadget: Refactor preparing TRBs
  usb: dwc3: gadget: Account for extra TRB
  usb: dwc3: gadget: Rename misleading function names
  usb: dwc3: ep0: Skip ZLP setup for OUT

 drivers/usb/dwc3/ep0.c    |   2 +-
 drivers/usb/dwc3/gadget.c | 232 ++++++++++++++++++++++----------------
 2 files changed, 137 insertions(+), 97 deletions(-)


base-commit: e3ee0e740c3887d2293e8d54a8707218d70d86ca
-- 
2.28.0

