Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F393E7F0E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhHJRhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233687AbhHJRfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10A396112D;
        Tue, 10 Aug 2021 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616908;
        bh=g6u9MC6VB7YyB0JK8nbLe/q2Qem+gXZ8+qzTdGX5y/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3ytQYqkOIcP0WaiCFQ14wRXHleDSV+abv//XMMAh0mgRKl5fYnWG35h9wBHePlcv
         K4/nRcSjR9cO2Ir4YCzvPz+shuXn5atntmk/nUxzwx6FC2lOnr7VthLVluanYIdZ1c
         5DCnz1iW7CyKE5Zk/o/kb93zv8wQui+cQNt6Uz6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.4 44/85] usb: cdns3: Fixed incorrect gadget state
Date:   Tue, 10 Aug 2021 19:30:17 +0200
Message-Id: <20210810172949.730043782@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit aa35772f61752d4c636d46be51a4f7ca6c029ee6 upstream.

For delayed status phase, the usb_gadget->state was set
to USB_STATE_ADDRESS and it has never been updated to
USB_STATE_CONFIGURED.
Patch updates the gadget state to correct USB_STATE_CONFIGURED.
As a result of this bug the controller was not able to enter to
Test Mode while using MSC function.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210623070247.46151-1-pawell@gli-login.cadence.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/ep0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -736,6 +736,7 @@ static int cdns3_gadget_ep0_queue(struct
 		request->actual = 0;
 		priv_dev->status_completion_no_call = true;
 		priv_dev->pending_status_request = request;
+		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
 		spin_unlock_irqrestore(&priv_dev->lock, flags);
 
 		/*


