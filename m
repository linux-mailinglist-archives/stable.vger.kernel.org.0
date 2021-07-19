Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E713CE288
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348036AbhGSPas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348001AbhGSPYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 359E9613E7;
        Mon, 19 Jul 2021 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710426;
        bh=yYpygZPIxpVH2TcmcNWlBa5D/UMWPo6vn70XF0/MG1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EL5mIF4UdTWkzxLAIMn5N/CD0jDsTI5AgwI5YNEwbjBIW4RIJfAuogbTs5GD+9/v2
         1Q1QUyhp8Mw5UkURmRVPY9q1oUIMNfT06KrMAA4xIQmWKmgGp3YPnYHEiLJShbmco5
         8cYKBhDVVWp/HnZhbtBXsVE06h+ju1G4TqIL84ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/243] firmware: arm_scmi: Reset Rx buffer to max size during async commands
Date:   Mon, 19 Jul 2021 16:53:59 +0200
Message-Id: <20210719144947.707705497@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index 6b2ce3f28f7b..f9901fadb3a4 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -268,6 +268,10 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
 		return;
 	}
 
+	/* rx.len could be shrunk in the sync do_xfer, so reset to maxsz */
+	if (msg_type == MSG_TYPE_DELAYED_RESP)
+		xfer->rx.len = info->desc->max_msg_size;
+
 	scmi_dump_header_dbg(dev, &xfer->hdr);
 
 	info->desc->ops->fetch_response(cinfo, xfer);
-- 
2.30.2



