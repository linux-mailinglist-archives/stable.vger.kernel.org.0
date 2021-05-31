Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677233961AB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhEaOpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhEaOlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D7561C65;
        Mon, 31 May 2021 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469195;
        bh=ejMJuLJ0WEYbmwOOtAcmZbty7rI2OOc8/VA/+lJBxP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7fZA/hitc8KD1ASnSMB7z2qFNIN4CTbAitMilBCmsgvOHo2u6Unp8TBqV+qppCfU
         zfSHLfwIow6CEIj4GrBScS9HD7pjcSQTM2y/B4x/FTP8T7R60ZfT8b5K5ahvGkKRQv
         TsWeI/b8Il0WO2Zx3ICX6spVJ7H6KrF190WUB43Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benjamin Berg <bberg@redhat.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.12 106/296] usb: typec: ucsi: Clear pending after acking connector change
Date:   Mon, 31 May 2021 15:12:41 +0200
Message-Id: <20210531130707.501215780@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -717,8 +717,8 @@ static void ucsi_handle_connector_change
 	ucsi_send_command(con->ucsi, command, NULL, 0);
 
 	/* 3. ACK connector change */
-	clear_bit(EVENT_PENDING, &ucsi->flags);
 	ret = ucsi_acknowledge_connector_change(ucsi);
+	clear_bit(EVENT_PENDING, &ucsi->flags);
 	if (ret) {
 		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
 		goto out_unlock;


