Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123654A4400
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351490AbiAaLZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377735AbiAaLXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A7F6125A;
        Mon, 31 Jan 2022 11:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B7C340E8;
        Mon, 31 Jan 2022 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628196;
        bh=MdEWgjRKDfc9GzOB4w6Dt4/YiyXxToHdfVqILfT/0eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwPJujxxv6JJmqiGRYqriDRH9zK19nHjviaUIHNRKGLJt7OEeDETLvIga34ut11lM
         GMxkvO3Mvdrg0Evk/BFYvx2xkhQeUWRXyb7CF1fVU8m1YHqb8xIJC4lxY1UxO1xX57
         L4hiIRNxDpqiKqB4tTxCUiKTITYH4VJVF+evKN68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Yanming Liu <yanminglr@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 155/200] Drivers: hv: balloon: account for vmbus packet header in max_pkt_size
Date:   Mon, 31 Jan 2022 11:56:58 +0100
Message-Id: <20220131105238.770439085@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanming Liu <yanminglr@gmail.com>

[ Upstream commit 96d9d1fa5cd505078534113308ced0aa56d8da58 ]

Commit adae1e931acd ("Drivers: hv: vmbus: Copy packets sent by Hyper-V
out of the ring buffer") introduced a notion of maximum packet size in
vmbus channel and used that size to initialize a buffer holding all
incoming packet along with their vmbus packet header. hv_balloon uses
the default maximum packet size VMBUS_DEFAULT_MAX_PKT_SIZE which matches
its maximum message size, however vmbus_open expects this size to also
include vmbus packet header. This leads to 4096 bytes
dm_unballoon_request messages being truncated to 4080 bytes. When the
driver tries to read next packet it starts from a wrong read_index,
receives garbage and prints a lot of "Unhandled message: type:
<garbage>" in dmesg.

Allocate the buffer with HV_HYP_PAGE_SIZE more bytes to make room for
the header.

Fixes: adae1e931acd ("Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer")
Suggested-by: Michael Kelley (LINUX) <mikelley@microsoft.com>
Suggested-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Yanming Liu <yanminglr@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/20220119202052.3006981-1-yanminglr@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_balloon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index ca873a3b98dbe..f2d05bff42453 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1660,6 +1660,13 @@ static int balloon_connect_vsp(struct hv_device *dev)
 	unsigned long t;
 	int ret;
 
+	/*
+	 * max_pkt_size should be large enough for one vmbus packet header plus
+	 * our receive buffer size. Hyper-V sends messages up to
+	 * HV_HYP_PAGE_SIZE bytes long on balloon channel.
+	 */
+	dev->channel->max_pkt_size = HV_HYP_PAGE_SIZE * 2;
+
 	ret = vmbus_open(dev->channel, dm_ring_size, dm_ring_size, NULL, 0,
 			 balloon_onchannelcallback, dev);
 	if (ret)
-- 
2.34.1



