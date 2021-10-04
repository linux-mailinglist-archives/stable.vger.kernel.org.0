Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6468F420D6A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhJDNPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236086AbhJDNNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:13:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E710461BA4;
        Mon,  4 Oct 2021 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352707;
        bh=eyC0Tzv53FFFU/5eHMqYw7yMEYbE1QpsRWtofhlR+C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRMlv67m1Pab/YrF/KPVVklP6ikEzPLK8OAujV3dSSQVXqJLVfwCTXTgay0RGepQ5
         NEIvnBPdedtWyMp6ZroSF87C13KSnZep6X2dl69PHEcI3EoEHACzOwChKTWNHfaBLH
         7eo9jjJW1YdjpTb/hJH633r/A6rqoicFmpUe+BmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 88/95] hso: fix bailout in error case of probe
Date:   Mon,  4 Oct 2021 14:52:58 +0200
Message-Id: <20211004125036.456344463@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
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
@@ -2368,7 +2368,7 @@ static int remove_net_device(struct hso_
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2391,7 +2391,7 @@ static void hso_free_net_device(struct h
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2567,7 +2567,7 @@ static struct hso_device *hso_create_net
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3130,7 +3130,7 @@ static void hso_free_interface(struct us
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i]);
+			hso_free_net_device(network_table[i], false);
 		}
 	}
 }


