Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFDD3E0050
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 13:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhHDLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 07:36:19 -0400
Received: from foss.arm.com ([217.140.110.172]:59650 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236502AbhHDLgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 07:36:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 196A013D5;
        Wed,  4 Aug 2021 04:36:07 -0700 (PDT)
Received: from e120937-lin.home (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9D5E3F719;
        Wed,  4 Aug 2021 04:36:05 -0700 (PDT)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        cristian.marussi@arm.com, Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH] firmware: arm_scmi: Add delayed response status check
Date:   Wed,  4 Aug 2021 12:35:55 +0100
Message-Id: <20210804113555.9021-1-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f1748b1ee1fa0fd1a074504045b530b62f949188 ]

A successfully received delayed response could anyway report a failure at
the protocol layer in the message status field.

Add a check also for this error condition.

Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/20210608103056.3388-1-cristian.marussi@arm.com
Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
Upstream commit f1748b1ee1fa0fd1a074504045b530b62f949188 has been already
applied to stable/linux-5.13.y, this is a backport with conflicts resolved
for v5.4 and v5.10 (The code fixed here was introduced after v4.19)
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 48e6e2b48924..4e43bdfa041f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -515,8 +515,12 @@ int scmi_do_xfer_with_response(const struct scmi_handle *handle,
 	xfer->async_done = &async_response;
 
 	ret = scmi_do_xfer(handle, xfer);
-	if (!ret && !wait_for_completion_timeout(xfer->async_done, timeout))
-		ret = -ETIMEDOUT;
+	if (!ret) {
+		if (!wait_for_completion_timeout(xfer->async_done, timeout))
+			ret = -ETIMEDOUT;
+		else if (xfer->hdr.status)
+			ret = scmi_to_linux_errno(xfer->hdr.status);
+	}
 
 	xfer->async_done = NULL;
 	return ret;
-- 
2.17.1

