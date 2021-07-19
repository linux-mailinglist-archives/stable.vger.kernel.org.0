Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82833CDFE3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345031AbhGSPMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344581AbhGSPKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B88D761279;
        Mon, 19 Jul 2021 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709884;
        bh=uBaSx1lWFnDdSLBAAROd3n+w/eciqLPZR3T7VwOFT7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leOnoA5/gn3LPSbIqlq6aM/AhxF0xR23L/FMnTEhxs3uGc45HyDLaInw+ssx5RO3N
         itwsnT2Md42UsZTof0K0Jx1NHTsTRioE/LlEc8KbAHAEFUNv792hKAe6oxfzh4xhQC
         C/5Oy168htwhNz5H6huJYS3bpy77hAF+97uuKBAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/149] firmware: arm_scmi: Reset Rx buffer to max size during async commands
Date:   Mon, 19 Jul 2021 16:53:57 +0200
Message-Id: <20210719144931.866666804@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 0cb7af474e0dbb2f500c67aa62b6db9fafa74de2 ]

During an async commands execution the Rx buffer length is at first set
to max_msg_sz when the synchronous part of the command is first sent.
However once the synchronous part completes the transport layer waits
for the delayed response which will be processed using the same xfer
descriptor initially allocated. Since synchronous response received at
the end of the xfer will shrink the Rx buffer length to the effective
payload response length, it needs to be reset again.

Raise the Rx buffer length again to max_msg_sz before fetching the
delayed response to ensure full response is read correctly from the
shared memory.

Link: https://lore.kernel.org/r/20210601102421.26581-2-cristian.marussi@arm.com
Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
[sudeep.holla: moved reset to scmi_handle_response as it could race with
               do_xfer_with_response]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 11078199abed..7b6903bad408 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -370,6 +370,10 @@ static void scmi_rx_callback(struct mbox_client *cl, void *m)
 
 	xfer = &minfo->xfer_block[xfer_id];
 
+	/* rx.len could be shrunk in the sync do_xfer, so reset to maxsz */
+	if (msg_type == MSG_TYPE_DELAYED_RESP)
+		xfer->rx.len = info->desc->max_msg_size;
+
 	scmi_dump_header_dbg(dev, &xfer->hdr);
 
 	scmi_fetch_response(xfer, mem);
-- 
2.30.2



