Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7376720BC7A
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 00:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgFZW2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 18:28:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34084 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgFZW2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 18:28:17 -0400
Received: by linux.microsoft.com (Postfix, from userid 1041)
        id 0A95A20B4901; Fri, 26 Jun 2020 15:28:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A95A20B4901
From:   Joseph Salisbury <joseph.salisbury@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, wei.liu@kernel.org, mikelley@microsoft.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH][v2] Drivers: hv: Change flag to write log level in panic msg to false
Date:   Fri, 26 Jun 2020 15:28:17 -0700
Message-Id: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Reply-To: joseph.salisbury@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the kernel panics, one page of kmsg data may be collected and sent to
Hyper-V to aid in diagnosing the failure.  The collected kmsg data typically
 contains 50 to 100 lines, each of which has a log level prefix that isn't
very useful from a diagnostic standpoint.  So tell kmsg_dump_get_buffer()
to not include the log level, enabling more information that *is* useful to
fit in the page.

Requesting in stable kernels, since many kernels running in production are
stable releases.

Cc: stable@vger.kernel.org
Signed-off-by: Joseph Salisbury <joseph.salisbury@microsoft.com>
---
 drivers/hv/vmbus_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 9147ee9d5f7d..d69f4efa3719 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1368,7 +1368,7 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
 	 * Write dump contents to the page. No need to synchronize; panic should
 	 * be single-threaded.
 	 */
-	kmsg_dump_get_buffer(dumper, true, hv_panic_page, HV_HYP_PAGE_SIZE,
+	kmsg_dump_get_buffer(dumper, false, hv_panic_page, HV_HYP_PAGE_SIZE,
 			     &bytes_written);
 	if (bytes_written)
 		hyperv_report_panic_msg(panic_pa, bytes_written);
-- 
2.17.1

