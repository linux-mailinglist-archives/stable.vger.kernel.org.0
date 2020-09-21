Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906D8272FB2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgIUQ7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbgIUQlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DEA239D1;
        Mon, 21 Sep 2020 16:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706497;
        bh=jOyl2Vi+KW94KMUqGZnGm+CTIEjrmMZWVNXSJ0OfgEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BU+Gwhc8gc/Au7WBmITSpBzobGcF2FA3K9CNnraFizuJV6lhGM2hJImtwGLU14uSZ
         q/vOx4lJFJgQZU+WXtfC5A02P09Rip5hIm4P/ZSTdR8yc3TWJOgwRsZBTUyXMc57aP
         guDbn5GAtxOBcJApJiLCvDqaKivsSpGobiGLAtr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 29/49] Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload
Date:   Mon, 21 Sep 2020 18:28:13 +0200
Message-Id: <20200921162035.937037969@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
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
index c83361a8e2033..7920b0d7e35a7 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -779,7 +779,7 @@ static void vmbus_wait_for_unload(void)
 	void *page_addr;
 	struct hv_message *msg;
 	struct vmbus_channel_message_header *hdr;
-	u32 message_type;
+	u32 message_type, i;
 
 	/*
 	 * CHANNELMSG_UNLOAD_RESPONSE is always delivered to the CPU which was
@@ -789,8 +789,11 @@ static void vmbus_wait_for_unload(void)
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



