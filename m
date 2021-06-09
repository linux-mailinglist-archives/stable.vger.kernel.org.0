Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0363A0DCF
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 09:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhFIHhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 03:37:45 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:47879 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFIHho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 03:37:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623224150; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=c0MwbkHmD93++vx2BU6gbFJyRd6o/+E+bfQJuaHSQPY=; b=jnUoyxkil70nOYADs62oD0eE8DIELRG1AwQZOioYdP0NfadEx6kgF1MXNfQ0TTXvasPJ10tV
 jVYM5vT1S6Tqay6jWBvABE1mMAGKDdacLrAtRIcfwf2YLgy4xJVX9T2V4J36L25lJ5WlKLrC
 RkdNyv5R+iO/GNfe2OI1L2xv52c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60c06f562eaeb98b5eca6999 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Jun 2021 07:35:50
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0AB14C43460; Wed,  9 Jun 2021 07:35:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E28A2C433F1;
        Wed,  9 Jun 2021 07:35:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E28A2C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
From:   Jack Pham <jackp@codeaurora.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-usb@vger.kernel.org, Mayank Rana <mrana@codeaurora.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>
Subject: [PATCH] usb: typec: ucsi: Clear PPM capability data in ucsi_init() error path
Date:   Wed,  9 Jun 2021 00:35:35 -0700
Message-Id: <20210609073535.5094-1-jackp@codeaurora.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mayank Rana <mrana@codeaurora.org>

If ucsi_init() fails for some reason (e.g. ucsi_register_port()
fails or general communication failure to the PPM), particularly at
any point after the GET_CAPABILITY command had been issued, this
results in unwinding the initialization and returning an error.
However the ucsi structure's ucsi_capability member retains its
current value, including likely a non-zero num_connectors.
And because ucsi_init() itself is done in a workqueue a UCSI
interface driver will be unaware that it failed and may think the
ucsi_register() call was completely successful.  Later, if
ucsi_unregister() is called, due to this stale ucsi->cap value it
would try to access the items in the ucsi->connector array which
might not be in a proper state or not even allocated at all and
results in NULL or invalid pointer dereference.

Fix this by clearing the ucsi->cap value to 0 during the error
path of ucsi_init() in order to prevent a later ucsi_unregister()
from entering the connector cleanup loop.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable@vger.kernel.org
Signed-off-by: Mayank Rana <mrana@codeaurora.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index b433169ef6fa..b7d104c80d85 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1253,6 +1253,7 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 err_reset:
+	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
 err:
 	return ret;
-- 
2.24.0

