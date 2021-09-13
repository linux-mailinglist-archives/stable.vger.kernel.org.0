Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4993B409572
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347263AbhIMOlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346806AbhIMOjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:39:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94BB460698;
        Mon, 13 Sep 2021 13:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541329;
        bh=m+rTPqoENtqtj2TZXeW4E1SejdlqGNQUDAe2NhIqw9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lk5d38t4Q956uUyOKb977XqptOrxEbltThmNqkviF9YX3SFSLR1wI078k7whaVxWx
         DzB6RrJg4uxmtwa5o6lkD9k68NXGdNG7g5AeMCE608QzLpDomU6Uz9iBQf1al3WoQO
         hO7CHn+9vhFNJvZo+ljNfr1wvmQJnCttihb3xzpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 255/334] hv_utils: Set the maximum packet size for VSS driver to the length of the receive buffer
Date:   Mon, 13 Sep 2021 15:15:09 +0200
Message-Id: <20210913131122.031369469@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 9d68cd9120e4e3af38f843e165631c323b86b4e4 ]

Commit adae1e931acd ("Drivers: hv: vmbus: Copy packets sent by Hyper-V out
of the ring buffer") introduced a notion of maximum packet size and for
KVM and FCOPY drivers set it to the length of the receive buffer. VSS
driver wasn't updated, this means that the maximum packet size is now
VMBUS_DEFAULT_MAX_PKT_SIZE (4k). Apparently, this is not enough. I'm
observing a packet of 6304 bytes which is being truncated to 4096. When
VSS driver tries to read next packet from ring buffer it starts from the
wrong offset and receives garbage.

Set the maximum packet size to 'HV_HYP_PAGE_SIZE * 2' in VSS driver. This
matches the length of the receive buffer and is in line with other utils
drivers.

Fixes: adae1e931acd ("Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20210825133857.847866-1-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_snapshot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 2267bd4c3472..6018b9d1b1fb 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -375,6 +375,7 @@ hv_vss_init(struct hv_util_service *srv)
 	}
 	recv_buffer = srv->recv_buffer;
 	vss_transaction.recv_channel = srv->channel;
+	vss_transaction.recv_channel->max_pkt_size = HV_HYP_PAGE_SIZE * 2;
 
 	/*
 	 * When this driver loads, the user level daemon that
-- 
2.30.2



