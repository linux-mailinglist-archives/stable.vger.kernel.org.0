Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DF3562D73
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiGAIJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiGAIJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:09:04 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024F46EEB4;
        Fri,  1 Jul 2022 01:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656662944; x=1688198944;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bv+bHqAlrS5dSgayycU0aCdMK8LHFKYhwKL0uZKnS50=;
  b=r8V3YwJ5wQMLaFu2XKDE81wRxRPoaj4YN/SxxlE2c3LAxZVC2VIOQHkw
   NGn8zX9ziT1WpdpbixMrY3q4McahKtX1xZ8NtAPqEjkyGy6a4KOCAlEIS
   2zxdfTXreCLyexPJf4IMdzqFLiXWqTO5yBpclJpgikUre2I+le3pQs2aU
   M=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 01 Jul 2022 01:09:03 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 01:09:03 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 1 Jul 2022 01:09:03 -0700
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 1 Jul 2022 01:09:01 -0700
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH v2] usb: typec: add missing uevent when partner support PD
Date:   Fri, 1 Jul 2022 16:08:54 +0800
Message-ID: <1656662934-10226-1-git-send-email-quic_linyyuan@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

System like Android allow user control power role from UI, it is possible
to implement application base on typec uevent to refresh UI, but found
there is chance that UI show different state from typec attribute file.

In typec_set_pwr_opmode(), when partner support PD, there is no uevent
send to user space which cause the problem.

Fix it by sending uevent notification when change power mode to PD.

Fixes: bdecb33af34f ("usb: typec: API for controlling USB Type-C Multiplexers")
Cc: stable@vger.kernel.org
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
---
v2: (v1 https://lore.kernel.org/linux-usb/1656637315-31229-1-git-send-email-quic_linyyuan@quicinc.com/)
    fix review comment from Greg,
    add Fixes tag,
    improve commit description.

 drivers/usb/typec/class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index bbc46b1..3da94f712 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1851,6 +1851,7 @@ void typec_set_pwr_opmode(struct typec_port *port,
 			partner->usb_pd = 1;
 			sysfs_notify(&partner_dev->kobj, NULL,
 				     "supports_usb_power_delivery");
+			kobject_uevent(&partner_dev->kobj, KOBJ_CHANGE);
 		}
 		put_device(partner_dev);
 	}
-- 
2.7.4

