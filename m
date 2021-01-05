Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA562EA58E
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbhAEGnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:43:41 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:47110 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbhAEGnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 01:43:41 -0500
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9B413401AA;
        Tue,  5 Jan 2021 06:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609828960; bh=I/WXH7/5xovYcW/npt/6xEfxvJV7cihX8hzNMRVFXIk=;
        h=Date:From:Subject:To:Cc:From;
        b=C7POY1ecbXoJxEq/MVP92lIhUlK9W18Jtt5Nvhp+/NMx5oivVSvXT0rZEciziz+hS
         gAHdO754ILe+xP6lys0eJt8aT7MMVo8GMsi7cCcKRTagw2k2UJdLuZ4CUarPG1Y/OU
         B9a7f+limemtIgsFuA+ujfdSJDBb9vfEowXD0dprl89LMiww9YQ80cRaYuYX+EcYTX
         JCqqst1QbEsai7PxF+Q+V1goc+I+M8ApJnwSsOHxFSSWvGkJKqafcmu8tMk/s29qC8
         oAVpZhQfXmE5w8oeXWIY4DuZZYMWluV5o8aDXg6WINEzv9PD4VbdqCKhjDv/QBIzKB
         WRpOIonWAYFSw==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 790BDA0096;
        Tue,  5 Jan 2021 06:42:39 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Mon, 04 Jan 2021 22:42:39 -0800
Date:   Mon, 04 Jan 2021 22:42:39 -0800
Message-Id: <b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2] usb: dwc3: gadget: Clear wait flag on dequeue
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an active transfer is dequeued, then the endpoint is freed to start a
new transfer. Make sure to clear the endpoint's transfer wait flag for
this case.

Cc: stable@vger.kernel.org
Fixes: e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - Only clear the wait flag if the selected request is of an active transfer.
   Otherwise, any dequeue will change the endpoint's state even if it's for
   some random request.

 drivers/usb/dwc3/gadget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 78cb4db8a6e4..9a00dcaca010 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1763,6 +1763,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
 			list_for_each_entry_safe(r, t, &dep->started_list, list)
 				dwc3_gadget_move_cancelled_request(r);
 
+			dep->flags &= ~DWC3_EP_WAIT_TRANSFER_COMPLETE;
+
 			goto out;
 		}
 	}

base-commit: 2edc7af892d0913bf06f5b35e49ec463f03d5ed8
-- 
2.28.0

