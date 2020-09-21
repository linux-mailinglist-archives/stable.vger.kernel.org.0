Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EE7272D62
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgIUQjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgIUQjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:39:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667C6238E6;
        Mon, 21 Sep 2020 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706382;
        bh=S94IViP3uOA7hn+c/uvNQhG2xCHnCJi1/+xBEnWvALo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MG655zLAF+NI6En9oCGbypVQVYLtjZUP14SSzgotNNgPKMjhHTQgSlAX5d3U9Pt5I
         lXEJ8uRgtHiSy9xUx/7WCPFC7pIlo3R8Y3xSsVTzQMN9tXjUdDiiO5PxnCUXs0xuX3
         yo+iWNJIoE3DcEzg9H6MTmcP4ZqEEJhAYUrmuGEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 77/94] Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload
Date:   Mon, 21 Sep 2020 18:28:04 +0200
Message-Id: <20200921162039.064901893@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 911e1987efc8f3e6445955fbae7f54b428b92bd3 ]

vmbus_wait_for_unload() looks for a CHANNELMSG_UNLOAD_RESPONSE message
coming from Hyper-V.  But if the message isn't found for some reason,
the panic path gets hung forever.  Add a timeout of 10 seconds to prevent
this.

Fixes: 415719160de3 ("Drivers: hv: vmbus: avoid scheduling in interrupt context in vmbus_initiate_unload()")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/1600026449-23651-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 462f7f363faab..5bf633c15cd4b 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -774,7 +774,7 @@ static void vmbus_wait_for_unload(void)
 	void *page_addr;
 	struct hv_message *msg;
 	struct vmbus_channel_message_header *hdr;
-	u32 message_type;
+	u32 message_type, i;
 
 	/*
 	 * CHANNELMSG_UNLOAD_RESPONSE is always delivered to the CPU which was
@@ -784,8 +784,11 @@ static void vmbus_wait_for_unload(void)
 	 * functional and vmbus_unload_response() will complete
 	 * vmbus_connection.unload_event. If not, the last thing we can do is
 	 * read message pages for all CPUs directly.
+	 *
+	 * Wait no more than 10 seconds so that the panic path can't get
+	 * hung forever in case the response message isn't seen.
 	 */
-	while (1) {
+	for (i = 0; i < 1000; i++) {
 		if (completion_done(&vmbus_connection.unload_event))
 			break;
 
-- 
2.25.1



