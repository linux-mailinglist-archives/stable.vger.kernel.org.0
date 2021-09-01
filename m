Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E5F3FDBB5
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344902AbhIAMnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345138AbhIAMkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADBB61183;
        Wed,  1 Sep 2021 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499825;
        bh=kHchV+KwZwfPlVmQdaqFWb9t3kmZdUgkIwJNkQdUk+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v80J85u8YrxW2YztoOPUH7EfWWuKBdWsHr+bR5ufrh6IODXsqSC02zjN3L0P4ewun
         wh8C7fTqai7GCuc5ZrxLAH/MdOM1TwSt20F7efh57O08QLv/A3/sRSaC4yb1iC59Yq
         02/VzPxPNZdoX1m8i2XRDn5RkEqwcwTpEOlKcFfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benjamin Berg <bberg@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.10 094/103] usb: typec: ucsi: Clear pending after acking connector change
Date:   Wed,  1 Sep 2021 14:28:44 +0200
Message-Id: <20210901122303.692592741@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 8c9b3caab3ac26db1da00b8117901640c55a69dd upstream.

It's possible that the interrupt handler for the UCSI driver signals a
connector changes after the handler clears the PENDING bit, but before
it has sent the acknowledge request. The result is that the handler is
invoked yet again, to ack the same connector change.

At least some versions of the Qualcomm UCSI firmware will not handle the
second - "spurious" - acknowledgment gracefully. So make sure to not
clear the pending flag until the change is acknowledged.

Any connector changes coming in after the acknowledgment, that would
have the pending flag incorrectly cleared, would afaict be covered by
the subsequent connector status check.

Fixes: 217504a05532 ("usb: typec: ucsi: Work around PPM losing change information")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-By: Benjamin Berg <bberg@redhat.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210516040953.622409-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -703,8 +703,8 @@ static void ucsi_handle_connector_change
 	ucsi_send_command(con->ucsi, command, NULL, 0);
 
 	/* 3. ACK connector change */
-	clear_bit(EVENT_PENDING, &ucsi->flags);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	clear_bit(EVENT_PENDING, &ucsi->flags);
 	if (ret) {
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 		goto out_unlock;


