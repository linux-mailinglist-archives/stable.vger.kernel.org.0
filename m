Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091D853D4F2
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 04:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiFDCzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiFDCzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 22:55:09 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E331EAC3;
        Fri,  3 Jun 2022 19:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654311307; x=1685847307;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xi1E92UnyzuRK698EaMWh0bgPz9x9TqRAxQCVUD2aJo=;
  b=dazk+UM2bOOF6+PQUXSRJRhf8A7vbRRRp4oRgo/SAPdHdErWifjw66/D
   CnPmEYvNZsT3zT6a85CjaG66cwWjdfhdk1EPqM8yICTEMyo2NvjIu+oNF
   +ilHVp87q+dhSIi0UQhEA4JcxsH6YfZf8z+zzGIx0MIrIXN6anHSCzFi9
   M=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 03 Jun 2022 19:55:07 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 19:55:06 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 3 Jun 2022 19:55:06 -0700
Received: from linyyuan-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 3 Jun 2022 19:55:04 -0700
From:   Linyu Yuan <quic_linyyuan@quicinc.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-usb@vger.kernel.org>, <stable@vger.kernel.org>,
        Jack Pham <quic_jackp@quicinc.com>,
        Michael Wu <michael@allwinnertech.com>,
        "John Keeping" <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH v4 0/2] usb: f_fs: safe operation in ffs_epfile_io()
Date:   Sat, 4 Jun 2022 10:54:53 +0800
Message-ID: <1654311295-9700-1-git-send-email-quic_linyyuan@quicinc.com>
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

Fix two possible issue in ffs_epfile_io() when operation at blocking mode.

v1: https://lore.kernel.org/linux-usb/1653989775-14267-1-git-send-email-quic_linyyuan@quicinc.com/
v2: correct interrupted variable according comment from John Keeping
v3: (v2: https://lore.kernel.org/linux-usb/1654006119-23869-1-git-send-email-quic_linyyuan@quicinc.com/)
    add Revived-by from John keeping,
    after offline discussion, add Reported-by from Michael Wu
v4: (v3: https://lore.kernel.org/linux-usb/1654056916-2062-1-git-send-email-quic_linyyuan@quicinc.com/)
    add Cc: <stable@vger.kernel.org> # 5.15  (seem other branch can't aplly cleanly),
    add Tested-by: Michael Wu <michael@allwinnertech.com>,
    remove one empty line to keep original code format.

Linyu Yuan (2):
  usb: gadget: f_fs: change ep->status safe in ffs_epfile_io()
  usb: gadget: f_fs: change ep->ep safe in ffs_epfile_io()

 drivers/usb/gadget/function/f_fs.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
2.7.4

