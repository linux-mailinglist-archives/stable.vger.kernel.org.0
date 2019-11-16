Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC60EFF068
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfKPQFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfKPPvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:20 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54CFB208CE;
        Sat, 16 Nov 2019 15:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919479;
        bh=x6hLt6z0ctPoVuvek0M26yoPRBeU6LO5WwNb4a7OFWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HU8umuJVVCuBeAFP9ZjEBzCp0PxOt9exApRUB5XTf8rYTz8qCnSlCLHAH4B8Dg+km
         MnTR48hrySHKXFxyRgnpG4Z9qcM6kIHRhbXXmlvEoUSJXMlHzdsmMQibCBJzGRBkMk
         tHKQxSG5845X5S585+TULAsizrgTaL2P7hpX5D/s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duncan Laurie <dlaurie@chromium.org>,
        Vadim Bendebury <vbendeb@chromium.org>,
        Stefan Reinauer <reinauer@chromium.org>,
        Furquan Shaikh <furquan@google.com>,
        Furquan Shaikh <furquan@chromium.org>,
        Aaron Durbin <adurbin@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Ross Zwisler <zwisler@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 12/99] gsmi: Fix bug in append_to_eventlog sysfs handler
Date:   Sat, 16 Nov 2019 10:49:35 -0500
Message-Id: <20191116155103.10971-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duncan Laurie <dlaurie@chromium.org>

[ Upstream commit 655603de68469adaff16842ac17a5aec9c9ce89b ]

The sysfs handler should return the number of bytes consumed, which in the
case of a successful write is the entire buffer.  Also fix a bug where
param.data_len was being set to (count - (2 * sizeof(u32))) instead of just
(count - sizeof(u32)).  The latter is correct because we skip over the
leading u32 which is our param.type, but we were also incorrectly
subtracting sizeof(u32) on the line where we were actually setting
param.data_len:

	param.data_len = count - sizeof(u32);

This meant that for our example event.kernel_software_watchdog with total
length 10 bytes, param.data_len was just 2 prior to this change.

To test, successfully append an event to the log with gsmi sysfs.
This sample event is for a "Kernel Software Watchdog"

> xxd -g 1 event.kernel_software_watchdog
0000000: 01 00 00 00 ad de 06 00 00 00

> cat event.kernel_software_watchdog > /sys/firmware/gsmi/append_to_eventlog

> mosys eventlog list | tail -1
14 | 2012-06-25 10:14:14 | Kernl Event | Software Watchdog

Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
Reviewed-by: Vadim Bendebury <vbendeb@chromium.org>
Reviewed-by: Stefan Reinauer <reinauer@chromium.org>
Signed-off-by: Furquan Shaikh <furquan@google.com>
Tested-by: Furquan Shaikh <furquan@chromium.org>
Reviewed-by: Aaron Durbin <adurbin@chromium.org>
Reviewed-by: Justin TerAvest <teravest@chromium.org>
[zwisler: updated changelog for 2nd bug fix and upstream]
Signed-off-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/gsmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c463871609764..98cdfc2ee0dff 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -480,11 +480,10 @@ static ssize_t eventlog_write(struct file *filp, struct kobject *kobj,
 	if (count < sizeof(u32))
 		return -EINVAL;
 	param.type = *(u32 *)buf;
-	count -= sizeof(u32);
 	buf += sizeof(u32);
 
 	/* The remaining buffer is the data payload */
-	if (count > gsmi_dev.data_buf->length)
+	if ((count - sizeof(u32)) > gsmi_dev.data_buf->length)
 		return -EINVAL;
 	param.data_len = count - sizeof(u32);
 
@@ -504,7 +503,7 @@ static ssize_t eventlog_write(struct file *filp, struct kobject *kobj,
 
 	spin_unlock_irqrestore(&gsmi_dev.lock, flags);
 
-	return rc;
+	return (rc == 0) ? count : rc;
 
 }
 
-- 
2.20.1

