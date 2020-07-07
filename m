Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA35217202
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgGGP1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgGGP1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABD920663;
        Tue,  7 Jul 2020 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135630;
        bh=CRpvTakR43SmP2tzl9DQZi6CTXB8+lf/9I6bpYv0GZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWC8hDqPbapi4l6zYnrxHfrl2kYMaM+heFhgqZpvaWfPsTw7CU+66gJlOwPnblQgq
         zbOqTuO+ka+7vW9NxhdS6A2af1hYjvXVWoiFqepdsAosZ30fHg6rHjuqYy1qgz86py
         b2weqyUYM/NWZ0dlohs1mL5B95dS3VRKDSIdDFIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.7 094/112] Drivers: hv: Change flag to write log level in panic msg to false
Date:   Tue,  7 Jul 2020 17:17:39 +0200
Message-Id: <20200707145805.449065113@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Salisbury <joseph.salisbury@microsoft.com>

commit 77b48bea2fee47c15a835f6725dd8df0bc38375a upstream.

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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/vmbus_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1328,7 +1328,7 @@ static void hv_kmsg_dump(struct kmsg_dum
 	 * Write dump contents to the page. No need to synchronize; panic should
 	 * be single-threaded.
 	 */
-	kmsg_dump_get_buffer(dumper, true, hv_panic_page, HV_HYP_PAGE_SIZE,
+	kmsg_dump_get_buffer(dumper, false, hv_panic_page, HV_HYP_PAGE_SIZE,
 			     &bytes_written);
 	if (bytes_written)
 		hyperv_report_panic_msg(panic_pa, bytes_written);


