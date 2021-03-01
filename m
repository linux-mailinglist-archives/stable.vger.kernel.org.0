Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CA3328530
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCAQuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235075AbhCAQnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90DB664EF2;
        Mon,  1 Mar 2021 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616176;
        bh=/opa7NkDfsggFxcZsiy5NCFhrJt9wStmMuH34R1yXeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR+pF8y4kXZzL/xGZk/TqxTpcE4BHXcAMhNXkAMX9i7MRtADNUgScmNOysw33CATu
         VuH6glygdKFCJXyCSIJAf1SstL6j63Upie/eyoXIY5sXdHlQzfe3yystslKnji4st1
         8B389CnFBpAP4Q+Q/dW/TL23P1E/aptAlMx1vQ4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/176] Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()
Date:   Mon,  1 Mar 2021 17:12:12 +0100
Message-Id: <20210301161023.880481531@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 5bf633c15cd4b..3891d3c2cc002 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -989,8 +989,7 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
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



