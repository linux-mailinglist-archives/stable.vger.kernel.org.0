Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605D4314257
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhBHVy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:54:27 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:57226 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235391AbhBHVyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 16:54:21 -0500
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BD613C008C;
        Mon,  8 Feb 2021 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1612821186; bh=YnF05UT6ySVr61Zj+a+THpPVOUiQjkWAD0CpyRmmRso=;
        h=Date:From:Subject:To:Cc:From;
        b=PLKQ6/D+mu1FHqgTVFjVFE+p2wQffGjs03Pmx5jUuSsdB7o16ZvH8AWoZ0piN1Gq4
         9D21j7fJTt5HbFwQ6xguVJ/GK3w93dt9eIXLx7G9gEWx4H00j6DKGg4nanYDu1PRNZ
         KQFKHoN276deO07bZIYQaFLdxjPN7y+ZpWFD+Dw1W5lhCsHuJLGzj9LklS0xs7s1Uz
         XxmRRWJ+JtM0cAyarPeN5eKWqYysyWU1fKj9C7FJPtF/WhzQlTC4FRVDQcoq3F4cPY
         T8W6esdAWQaxEKA4G3H+ve23ukkOlaenlI7LKKgiJcCiXJdxrfe+eQWoKr2D1LC5Ng
         DCiDhVw4u17uA==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5C102A024E;
        Mon,  8 Feb 2021 21:53:04 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 08 Feb 2021 13:53:03 -0800
Date:   Mon, 08 Feb 2021 13:53:03 -0800
Message-Id: <cover.1612820995.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/2] usb: dwc3: gadget: Fix fullspeed interval setting
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dwc3 driver did not account for operating in fullspeed when setting
DEPCFG.bInterval_m1. This series fixes it.

Note that for some bInterval, some IP versions may not exhibit invalid behavior
from the invalid DEPCFG.bInterval_m1 setting, which may mask this issue.


Thinh Nguyen (2):
  usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1
  usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

 drivers/usb/dwc3/gadget.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


base-commit: d8c849037d9398abe6a5f5d065eafc777eb3bdaf
-- 
2.28.0

