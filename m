Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53946580BD4
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbiGZGqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 02:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiGZGp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 02:45:58 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011BD21253;
        Mon, 25 Jul 2022 23:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658817957; x=1690353957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sJTf3AJoEE0c1OYNZJV14wvr0FYVG9lw9EJa1bA1O5Y=;
  b=du76/kFRG6hTqC6/zS92HjhIcl+4+LIIK3YQHVQfx4Tg1lztKudOX+HA
   QfCMpRx3RL7OxDqz+mM7H0SMKDKrDc4JxNuMG6jzkHvA+aKiiaMD578wP
   Xlpxk9JH6Vz0lQfGFalrWiLRMdVWufRSQNpNfaUGT2pw+gA/7h2qtfhwR
   Y=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 25 Jul 2022 23:45:57 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 23:45:56 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 23:45:56 -0700
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 25 Jul 2022 23:45:54 -0700
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jack Pham <quic_jackp@quicinc.com>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH] usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion
Date:   Tue, 26 Jul 2022 14:45:49 +0800
Message-ID: <1658817949-4632-1-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found PPM will not send any notification after it report error status
and OPM issue GET_ERROR_STATUS command to read the details about error.

According UCSI spec, PPM may clear the Error Status Data after the OPM
has acknowledged the command completion.

This change add operation to acknowledge the command completion from PPM.

Fixes: bdc62f2bae8f (usb: typec: ucsi: Simplified registration and I/O API)
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index cbd862f..1aea464 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -76,6 +76,10 @@ static int ucsi_read_error(struct ucsi *ucsi)
 	if (ret)
 		return ret;
 
+	ret = ucsi_acknowledge_command(ucsi);
+	if (ret)
+		return ret;
+
 	switch (error) {
 	case UCSI_ERROR_INCOMPATIBLE_PARTNER:
 		return -EOPNOTSUPP;
-- 
2.7.4

