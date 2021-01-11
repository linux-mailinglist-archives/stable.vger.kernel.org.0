Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D32F14A6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbhAKN1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:27:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbhAKNQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 464C322AAF;
        Mon, 11 Jan 2021 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370971;
        bh=FsuDOkHrxy651SKBoo84r3hTfRxp6uYKARxYY0rNnTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4A32IC+NFkNQ0LFhKpw4rzX5b2OTb0cvnfo77tXCGyRPepSNY2sWu8r05nHLRugb
         9t7WOOZ1iINf7IaqewlvgRnEqTh6v412w6m4r6/TTsHoLgckcAoPrOwQesw9NDNiHt
         Nyiy+zMRA8E/lqT+ubiTCIVQ7BZBv/UTRWiuVT1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 084/145] usb: dwc3: gadget: Clear wait flag on dequeue
Date:   Mon, 11 Jan 2021 14:01:48 +0100
Message-Id: <20210111130052.566672513@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit a5c7682aaaa10e42928d73de1c9e1e02d2b14c2e upstream.

If an active transfer is dequeued, then the endpoint is freed to start a
new transfer. Make sure to clear the endpoint's transfer wait flag for
this case.

Fixes: e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1763,6 +1763,8 @@ static int dwc3_gadget_ep_dequeue(struct
 			list_for_each_entry_safe(r, t, &dep->started_list, list)
 				dwc3_gadget_move_cancelled_request(r);
 
+			dep->flags &= ~DWC3_EP_WAIT_TRANSFER_COMPLETE;
+
 			goto out;
 		}
 	}


