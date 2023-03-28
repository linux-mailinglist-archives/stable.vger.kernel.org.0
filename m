Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510A96CC415
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjC1O75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjC1O7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B909E3A8
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D56EBB81D74
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D94C433EF;
        Tue, 28 Mar 2023 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015574;
        bh=3HSw5GrGlb8OURGcOqdLBKiuJyTlo9z7n7kfG/EjQfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/24uIXzHyIlxkX3GYZBl3Yjg4azHmHRNqCobkr78RahVc8wz+IbCR0zcnrGdlpTR
         JY/Ppww5qrau3gV4c2eEyqFQSYkqDoW7aHbFcdoZ4pbv4tHBMqw6sdEvWqgBOWPs93
         uuzZ0AZGb6fpQwB2b8Dex5g80/uRhaV5GnBlz2YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/224] Bluetooth: hci_core: Detect if an ACL packet is in fact an ISO packet
Date:   Tue, 28 Mar 2023 16:41:17 +0200
Message-Id: <20230328142620.670805916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 876e78104f23ce9267822757a63562a609b126c3 ]

Because some transports don't have a dedicated type for ISO packets
(see 14202eff214e1e941fefa0366d4c3bc4b1a0d500) they may use ACL type
when in fact they are ISO packets.

In the past this was left for the driver to detect such thing but it
creates a problem when using the likes of btproxy when used by a VM as
the host would not be aware of the connection the guest is doing it
won't be able to detect such behavior, so this make bt_recv_frame
detect when it happens as it is the common interface to all drivers
including guest VMs.

Fixes: 14202eff214e ("Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b65c3aabcd536..334e308451f53 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2871,10 +2871,25 @@ int hci_recv_frame(struct hci_dev *hdev, struct sk_buff *skb)
 		return -ENXIO;
 	}
 
-	if (hci_skb_pkt_type(skb) != HCI_EVENT_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_ACLDATA_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_SCODATA_PKT &&
-	    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT) {
+	switch (hci_skb_pkt_type(skb)) {
+	case HCI_EVENT_PKT:
+		break;
+	case HCI_ACLDATA_PKT:
+		/* Detect if ISO packet has been sent as ACL */
+		if (hci_conn_num(hdev, ISO_LINK)) {
+			__u16 handle = __le16_to_cpu(hci_acl_hdr(skb)->handle);
+			__u8 type;
+
+			type = hci_conn_lookup_type(hdev, hci_handle(handle));
+			if (type == ISO_LINK)
+				hci_skb_pkt_type(skb) = HCI_ISODATA_PKT;
+		}
+		break;
+	case HCI_SCODATA_PKT:
+		break;
+	case HCI_ISODATA_PKT:
+		break;
+	default:
 		kfree_skb(skb);
 		return -EINVAL;
 	}
-- 
2.39.2



