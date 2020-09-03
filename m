Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B163D25B85A
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 03:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgICBm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 21:42:57 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:50692 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgICBmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 21:42:54 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A6D10C00B2;
        Thu,  3 Sep 2020 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1599097373; bh=1UIyxk96xT7j81Ue2i1Pp0leyDJRlUXaTtX35F3xV5s=;
        h=Date:From:Subject:To:Cc:From;
        b=cRs3UEcakkIDElaqkYd9SZsclCbBLXqy5cZDWDugDhtWNZDLohZsnww18SgBn+6IF
         VjssnhcuWCWNThwp2g+T78wp2uGhX5rTjzQkcFXALC1VR3qkqHk3KD28qLsNxFr6v3
         +cHNm/o5ZtYu9WB3y97oEmwH2Y9HW4UonllxiSMeJ4JKm2zclK+/9JCNRBXlw11vRp
         07D1XsLlOgmbnJ/0QQzQ0DCQ5QMwAZCF5jhsmPvWjk7jY2koyQ6QMA8ECs7BHYJ1Vo
         Nx68SJUkK/Oc+WLXvWQnRCFL5H+ZBUqIpbHxehK+BCk+YnrooVpQH5EfH7OiRQJDuW
         jdYs1SEGk/XkQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C39E7A005E;
        Thu,  3 Sep 2020 01:42:51 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 02 Sep 2020 18:42:51 -0700
Date:   Wed, 02 Sep 2020 18:42:51 -0700
Message-Id: <cover.1599096763.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 0/2] usb: dwc3: gadget: Fix halt/clear_stall handling
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes a couple of driver issues handling ClearFeature(halt)
request:

1) A function driver often uses set_halt() to reject a class driver protocol
command. After set_halt(), the endpoint will be stalled. It can queue new
requests while the endpoint is stalled. However, dwc3 currently drops those
requests after CLEAR_STALL. The driver should only drop started requests. Keep
the pending requests in the pending list to resume and process them after the
host issues ClearFeature(Halt) to the endpoint.

2) DWC3 should issue CLEAR_STALL command _after_ END_TRANSFER command completes.

Changes in v2:
- Rebased on 5.9-rc3
- Remove a cleanup patch so this series can be merged to 5.9-rcX
- Account for wedged endpoint
- Account for CLEAR_FEATURE on stopped endpoints with pending requests
  (END_TRANSFER command won't be issued for stopped endpoints, so just kick
  pending request right after CLEAR_STALL)


Thinh Nguyen (2):
  usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
  usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command

 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/ep0.c    | 16 +++++++++++
 drivers/usb/dwc3/gadget.c | 56 ++++++++++++++++++++++++++++++---------
 drivers/usb/dwc3/gadget.h |  1 +
 4 files changed, 61 insertions(+), 13 deletions(-)


base-commit: f75aef392f869018f78cfedf3c320a6b3fcfda6b
-- 
2.28.0

