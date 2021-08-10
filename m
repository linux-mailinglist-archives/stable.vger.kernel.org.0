Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9892F3E7FF5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhHJRpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235795AbhHJRnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D7760F94;
        Tue, 10 Aug 2021 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617151;
        bh=DoV5vHuMG6kNwCUV47p0+YaRnSi88p7jjC3YdvCAUr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx4DPFiumOwBboTAfgEMdH0k03J8udCs8WOQGzLBSlSnXjp3Q315CrZPDWlg+lxkO
         B33+bXDRyAkWIgOKxmYbPmOvF9LJOUXPu2Sw1v4wCBX0UPpcZyJdi4DBN3WMmbSREV
         ZRYdO8hypg7T7H0Jv/xBEPfQkpjq4KAIShddZdd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.10 066/135] usb: cdns3: Fixed incorrect gadget state
Date:   Tue, 10 Aug 2021 19:30:00 +0200
Message-Id: <20210810172957.948251993@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct
 		request->actual = 0;
 		priv_dev->status_completion_no_call = true;
 		priv_dev->pending_status_request = request;
+		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
 		spin_unlock_irqrestore(&priv_dev->lock, flags);
 
 		/*


