Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E6295C22
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 11:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895871AbgJVJmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 05:42:35 -0400
Received: from z5.mailgun.us ([104.130.96.5]:46650 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509624AbgJVJme (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 05:42:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603359754; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=8aaAMdYqs+upyudwyIYgvScBv6SYP1Mn3fkUIX2rz98=; b=KTJDVHfNjGAXFp5WCQMQx9KhEmS7NAjxWRY8Y4DBl42Z4OrY4Lqynwfao2OB2EQ2l1bJODv2
 ClKr55NmZfj98OFGWktfDdTAQHynwb8EN7k5ICAtxJQ8Myd6ye8sUsWaUD8PRGk8f7QvByw/
 xZJChCdwsq4LoHQSg2p+eZirRnQ=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f915409a03b63d6736f809e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Oct 2020 09:42:33
 GMT
Sender: sallenki=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A132EC433CB; Thu, 22 Oct 2020 09:42:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from sallenki-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sallenki)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9AE8EC433CB;
        Thu, 22 Oct 2020 09:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9AE8EC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sallenki@codeaurora.org
From:   Sriharsha Allenki <sallenki@codeaurora.org>
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackp@codeaurora.org, mgautam@codeaurora.org,
        Sriharsha Allenki <sallenki@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH] usb: typec: Prevent setting invalid opmode value
Date:   Thu, 22 Oct 2020 15:12:14 +0530
Message-Id: <1603359734-2931-1-git-send-email-sallenki@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Setting opmode to invalid values would lead to a
paging fault failure when there is an access to the
power_operation_mode.

Prevent this by checking the validity of the value
that the opmode is being set.

Cc: <stable@vger.kernel.org>
Fixes: fab9288428ec ("usb: USB Type-C connector class")
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
---
 drivers/usb/typec/class.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 35eec70..63efe16 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1427,7 +1427,8 @@ void typec_set_pwr_opmode(struct typec_port *port,
 {
 	struct device *partner_dev;
 
-	if (port->pwr_opmode == opmode)
+	if ((port->pwr_opmode == opmode) || (opmode < TYPEC_PWR_MODE_USB) ||
+						(opmode > TYPEC_PWR_MODE_PD))
 		return;
 
 	port->pwr_opmode = opmode;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

