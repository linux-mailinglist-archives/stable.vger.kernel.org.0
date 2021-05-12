Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309AC37CC07
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbhELQjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhELQcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4042D61C25;
        Wed, 12 May 2021 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835102;
        bh=nmCCMO0xcWuTtvzIeFyD7Q9ZizsvSHb5TM/CFeJMczc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HMhQBproOhRekV+HNlhoE9qXo41QR8UR+tG0m9f/AI9JmWhdyrq0FWOa62o5evwN
         SUEiwmXE0iWxOBD1bZ6erdKnQ77OfIXkeQqo83MbkcCw9jzSFQArqhf6tyBiUqERYd
         zNxGPByNNywov6rmsqvcolTeirVeZhWXIClVNY6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 209/677] Drivers: hv: vmbus: Drop error message when No request id available
Date:   Wed, 12 May 2021 16:44:15 +0200
Message-Id: <20210512144844.189684943@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 0c85c54bf7faeb80c6b76901ed77d93acef0207d ]

Running out of request IDs on a channel essentially produces the same
effect as running out of space in the ring buffer, in that -EAGAIN is
returned.  The error message in hv_ringbuffer_write() should either be
dropped (since we don't output a message when the ring buffer is full)
or be made conditional/debug-only.

Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Fixes: e8b7db38449ac ("Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus hardening")
Link: https://lore.kernel.org/r/20210301191348.196485-1-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/ring_buffer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 35833d4d1a1d..ecd82ebfd5bc 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -313,7 +313,6 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 		rqst_id = vmbus_next_request_id(&channel->requestor, requestid);
 		if (rqst_id == VMBUS_RQST_ERROR) {
 			spin_unlock_irqrestore(&outring_info->ring_lock, flags);
-			pr_err("No request id available\n");
 			return -EAGAIN;
 		}
 	}
-- 
2.30.2



