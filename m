Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A010519BB2C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 06:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgDBEpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 00:45:49 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:47327 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgDBEpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 00:45:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585802748; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=5G2EqSwTsP/7tRuDsueSsigMRBux1Pi62z3VGJoVwuY=; b=rvmPsZvNCRrUtiP6JWMBHLSUiL7+PlLXmo1JeJPyArBX6BgAS10RUQSdgU5MfW8X7lC2akZ7
 UPFsZCX0+R9dZYyweOJD0UFyusXiCq+eaGPyzNmA0xbAp0tVzJUdPm9SlzkKVRrrrZoS+g2J
 HKe+pDfI4wUDys+1AnFe3I7H4Q8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e856dec.7fbdc71a5570-smtp-out-n04;
 Thu, 02 Apr 2020 04:45:32 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D89EDC433BA; Thu,  2 Apr 2020 04:45:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from sallenki-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sallenki)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E0D9C433F2;
        Thu,  2 Apr 2020 04:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9E0D9C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=sallenki@codeaurora.org
From:   Sriharsha Allenki <sallenki@codeaurora.org>
To:     balbi@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, ugoswami@codeaurora.org
Cc:     mgautam@codeaurora.org, jackp@codeaurora.org,
        stable@vger.kernel.org, Sriharsha Allenki <sallenki@codeaurora.org>
Subject: [PATCH v2] usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_reset()
Date:   Thu,  2 Apr 2020 10:15:21 +0530
Message-Id: <20200402044521.9312-1-sallenki@codeaurora.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <ugoswami@codeaurora.org>

For userspace functions using OS Descriptors, if a function also supplies
Extended Property descriptors currently the counts and lengths stored in
the ms_os_descs_ext_prop_{count,name_len,data_len} variables are not
getting reset to 0 during an unbind or when the epfiles are closed. If
the same function is re-bound and the descriptors are re-written, this
results in those count/length variables to monotonically increase
causing the VLA allocation in _ffs_func_bind() to grow larger and larger
at each bind/unbind cycle and eventually fail to allocate.

Fix this by clearing the ms_os_descs_ext_prop count & lengths to 0 in
ffs_data_reset().

Fixes: f0175ab51993 ("usb: gadget: f_fs: OS descriptors support")
Cc: stable@vger.kernel.org
Signed-off-by: Udipto Goswami <ugoswami@codeaurora.org>
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
Reviewed-by: Manu Gautam <mgautam@codeaurora.org>
---
Changes from v1:
	- Removed Change-ID

 drivers/usb/gadget/function/f_fs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c81023b195c3..10f01f974f67 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1813,6 +1813,10 @@ static void ffs_data_reset(struct ffs_data *ffs)
 	ffs->state = FFS_READ_DESCRIPTORS;
 	ffs->setup_state = FFS_NO_SETUP;
 	ffs->flags = 0;
+
+	ffs->ms_os_descs_ext_prop_count = 0;
+	ffs->ms_os_descs_ext_prop_name_len = 0;
+	ffs->ms_os_descs_ext_prop_data_len = 0;
 }
 
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
