Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE3148371
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404739AbgAXLgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404887AbgAXLgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A917214AF;
        Fri, 24 Jan 2020 11:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865769;
        bh=+PXbwDiudaVGICJcW9K7f8hU1Y36cPzlHj6uTliGLNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7ClZKTz9/gXQxXIvlTsO+oTp8Wc1DQGxPU1/iPz7ZgFady8vQG0Dktx3nPvTlbSB
         Pyhh6UW+gwFkRM8odd5KSyDJY3hZc2qNf2qBJw5rmFVQ3CAE4ZyV1BldIP+ZYljmdK
         wumHXzKnRbl8HofsfASOG2uAz1zW4OOdc2Nb6FjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 616/639] hv_netvsc: Fix send_table offset in case of a host bug
Date:   Fri, 24 Jan 2020 10:33:06 +0100
Message-Id: <20200124093206.751764426@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 171c1fd98df3d5948d9a9eb755274850fa5e59c6 ]

If negotiated NVSP version <= NVSP_PROTOCOL_VERSION_6, the offset may
be wrong (too small) due to a host bug. This can cause missing the
end of the send indirection table, and add multiple zero entries from
leading zeros before the data region. This bug adds extra burden on
channel 0.

So fix the offset by computing it from the data structure sizes. This
will ensure netvsc driver runs normally on unfixed hosts, and future
fixed hosts.

Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scaling (vRSS)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 68c23a64e565f..dbfd3a0c97d3b 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1182,6 +1182,7 @@ static int netvsc_receive(struct net_device *ndev,
 }
 
 static void netvsc_send_table(struct net_device *ndev,
+			      struct netvsc_device *nvscdev,
 			      const struct nvsp_message *nvmsg,
 			      u32 msglen)
 {
@@ -1197,6 +1198,16 @@ static void netvsc_send_table(struct net_device *ndev,
 		return;
 	}
 
+	/* If negotiated version <= NVSP_PROTOCOL_VERSION_6, the offset may be
+	 * wrong due to a host bug. So fix the offset here.
+	 */
+	if (nvscdev->nvsp_version <= NVSP_PROTOCOL_VERSION_6 &&
+	    msglen >= sizeof(struct nvsp_message_header) +
+	    sizeof(union nvsp_6_message_uber) + count * sizeof(u32))
+		offset = sizeof(struct nvsp_message_header) +
+			 sizeof(union nvsp_6_message_uber);
+
+	/* Boundary check for all versions */
 	if (offset > msglen - count * sizeof(u32)) {
 		netdev_err(ndev, "Received send-table offset too big:%u\n",
 			   offset);
@@ -1222,12 +1233,13 @@ static void netvsc_send_vf(struct net_device *ndev,
 }
 
 static void netvsc_receive_inband(struct net_device *ndev,
+				  struct netvsc_device *nvscdev,
 				  const struct nvsp_message *nvmsg,
 				  u32 msglen)
 {
 	switch (nvmsg->hdr.msg_type) {
 	case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
-		netvsc_send_table(ndev, nvmsg, msglen);
+		netvsc_send_table(ndev, nvscdev, nvmsg, msglen);
 		break;
 
 	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
@@ -1260,7 +1272,7 @@ static int netvsc_process_raw_pkt(struct hv_device *device,
 		break;
 
 	case VM_PKT_DATA_INBAND:
-		netvsc_receive_inband(ndev, nvmsg, msglen);
+		netvsc_receive_inband(ndev, net_device, nvmsg, msglen);
 		break;
 
 	default:
-- 
2.20.1



