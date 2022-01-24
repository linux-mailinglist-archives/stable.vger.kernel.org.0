Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAF499237
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiAXUSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbiAXUN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC87FB810BD;
        Mon, 24 Jan 2022 20:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D904C340E5;
        Mon, 24 Jan 2022 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055233;
        bh=oM9XJ6lkMtHrXDqXRQuGbTYoOCRv3BOX3desWydiKQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dhqk25IlSh+VbzFu9jM3o/OzwzP3hb2kSMYSeyNBXt2GMO3Ct/D9xPtkFeqWbUlqr
         c/Q7tgpMX0bL+/TmJji/lpbs8aN/F7BHYGplnE/adbCdjTGdz1Bfq3rzEh1a4jEpS5
         +/9hP3sIKUPaDta/4YVTCk1ZJQo83gCioBpK5hww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Soenke Huster <soenke.huster@eknoes.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/846] Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()
Date:   Mon, 24 Jan 2022 19:33:22 +0100
Message-Id: <20220124184103.918696402@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit 1d0688421449718c6c5f46e458a378c9b530ba18 ]

On the reception of packets with an invalid packet type, the memory of
the allocated socket buffers is never freed. Add a default case that frees
these to avoid a memory leak.

Fixes: afd2daa26c7a ("Bluetooth: Add support for virtio transport driver")
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/virtio_bt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 57908ce4fae85..076e4942a3f0e 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -202,6 +202,9 @@ static void virtbt_rx_handle(struct virtio_bluetooth *vbt, struct sk_buff *skb)
 		hci_skb_pkt_type(skb) = pkt_type;
 		hci_recv_frame(vbt->hdev, skb);
 		break;
+	default:
+		kfree_skb(skb);
+		break;
 	}
 }
 
-- 
2.34.1



