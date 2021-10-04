Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56283420DE0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhJDNTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236400AbhJDNSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF1561A0C;
        Mon,  4 Oct 2021 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352853;
        bh=H/V/BK1OADXDtIVYSpcmx5JkuXA+3Dyb08c/OUVesKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIMg7cDE4SUoddWAOZPL8CHFcJWPMc7rTSaxHT5ByQLj4LcYuC9QmzWwCXypeKhTx
         UaB8avPSHFwIXh0pCLBzDVt/xBa3gAToI37ddHbwvjDdSk+/oJ360/2jINxtGdER30
         yKq+t0vJG9K7+9SEQqBc9IM614KLTmSQzbNYjwd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 49/56] hso: fix bailout in error case of probe
Date:   Mon,  4 Oct 2021 14:53:09 +0200
Message-Id: <20211004125031.545056527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 5fcfb6d0bfcda17f0d0656e4e5b3710af2bbaae5 upstream.

The driver tries to reuse code for disconnect in case
of a failed probe.
If resources need to be freed after an error in probe, the
netdev must not be freed because it has never been registered.
Fix it by telling the helper which path we are in.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2354,7 +2354,7 @@ static int remove_net_device(struct hso_
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2377,7 +2377,7 @@ static void hso_free_net_device(struct h
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2553,7 +2553,7 @@ static struct hso_device *hso_create_net
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3120,7 +3120,7 @@ static void hso_free_interface(struct us
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i]);
+			hso_free_net_device(network_table[i], false);
 		}
 	}
 }


