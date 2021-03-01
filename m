Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6991328861
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhCARjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238265AbhCARb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:31:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F46E65099;
        Mon,  1 Mar 2021 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617549;
        bh=YOZCW01aqDWkM/5MmhBJFZakqJlSWv7MVU56U5ghlkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbtTDcDgk1dLWNezB0ipNrEag3LL51p9+dIj4J0Bb3oKSKRxUyrRD2HiPPxPAua0f
         QApovye3fwEe5pLRU95Z7pPd9hQEgrfqn6jYEMLc+4JxF7KY3e0Q9h1D0Rr4quJtpj
         etXD6P6zh2oFkkf4oHRZMh1OQcy5M8P3wnL2BIaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/340] Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()
Date:   Mon,  1 Mar 2021 17:10:57 +0100
Message-Id: <20210301161053.899475667@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit e3fa4b747f085d2cda09bba0533b86fa76038635 ]

When channel->device_obj is non-NULL, vmbus_onoffer_rescind() could
invoke put_device(), that will eventually release the device and free
the channel object (cf. vmbus_device_release()).  However, a pointer
to the object is dereferenced again later to load the primary_channel.
The use-after-free can be avoided by noticing that this load/check is
redundant if device_obj is non-NULL: primary_channel must be NULL if
device_obj is non-NULL, cf. vmbus_add_channel_work().

Fixes: 54a66265d6754b ("Drivers: hv: vmbus: Fix rescind handling")
Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20201209070827.29335-5-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 452307c79e4b9..0b55bc146b292 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -1101,8 +1101,7 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 			vmbus_device_unregister(channel->device_obj);
 			put_device(dev);
 		}
-	}
-	if (channel->primary_channel != NULL) {
+	} else if (channel->primary_channel != NULL) {
 		/*
 		 * Sub-channel is being rescinded. Following is the channel
 		 * close sequence when initiated from the driveri (refer to
-- 
2.27.0



