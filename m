Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FE63CE413
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347640AbhGSPmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348898AbhGSPff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CBBF61248;
        Mon, 19 Jul 2021 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711313;
        bh=xuWbw3UXh3nhvGk7DfHzJ+IA9prvE/TmTKUoeTavg4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZOkGcb0tCbQ+c788uILhDuEZEhtj2gQEoF+CPw5rwFAx95wRwrAxiACZQdwJH381
         97OvHLaCPbZbaCofHExSL5W44SXYawjBkCU+bQcGJquFoC6s/+5Sv+vIjKItXPN5Ru
         0VzddKOS6q1ak3TkLs25Nabey4mPPpfydVhXYI70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 306/351] firmware: arm_scmi: Reset Rx buffer to max size during async commands
Date:   Mon, 19 Jul 2021 16:54:12 +0200
Message-Id: <20210719144955.171594013@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 66eb3f0e5daf..5e8e9337adc7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -335,6 +335,10 @@ static void scmi_handle_response(struct scmi_chan_info *cinfo,
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



