Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596713A60D4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhFNKiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233613AbhFNKgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1A3611C1;
        Mon, 14 Jun 2021 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666785;
        bh=a3FK9UDXjjavE0Rd+YnPxUmCeg7rAl3DHAPTtV5WDeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=140X9gdrGSrcb9iGzbK0OyWFQ6BbGrO9APclZi5meXwYPdLGYSw7MbuCg7whqer7s
         hAasuFf86dzlzKUr8bNP51f8j46t7co0jGYQPyH1pg7egUV4KsS9MXDpQxrk5W0E72
         jlg4YH3h+BWKA+kjLkeIbD7Cpq5wEk7BGx9dz8FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mayank Rana <mrana@codeaurora.org>,
        Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 4.14 29/49] usb: typec: ucsi: Clear PPM capability data in ucsi_init() error path
Date:   Mon, 14 Jun 2021 12:27:22 +0200
Message-Id: <20210614102642.822191363@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mayank Rana <mrana@codeaurora.org>

commit f247f0a82a4f8c3bfed178d8fd9e069d1424ee4e upstream.

If ucsi_init() fails for some reason (e.g. ucsi_register_port()
fails or general communication failure to the PPM), particularly at
any point after the GET_CAPABILITY command had been issued, this
results in unwinding the initialization and returning an error.
However the ucsi structure's ucsi_capability member retains its
current value, including likely a non-zero num_connectors.
And because ucsi_init() itself is done in a workqueue a UCSI
interface driver will be unaware that it failed and may think the
ucsi_register() call was completely successful.  Later, if
ucsi_unregister() is called, due to this stale ucsi->cap value it
would try to access the items in the ucsi->connector array which
might not be in a proper state or not even allocated at all and
results in NULL or invalid pointer dereference.

Fix this by clearing the ucsi->cap value to 0 during the error
path of ucsi_init() in order to prevent a later ucsi_unregister()
from entering the connector cleanup loop.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Mayank Rana <mrana@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210609073535.5094-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -724,6 +724,7 @@ err_unregister:
 	}
 
 err_reset:
+	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
 err:
 	mutex_unlock(&ucsi->ppm_lock);


