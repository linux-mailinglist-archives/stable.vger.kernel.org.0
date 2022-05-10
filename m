Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5913E5219CF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbiEJNv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343550AbiEJNsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE252B09D4;
        Tue, 10 May 2022 06:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF46C618AF;
        Tue, 10 May 2022 13:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA789C385A6;
        Tue, 10 May 2022 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189793;
        bh=NKaUkUPhvYFyVUYBOa93qXmG/LU5ZJShTPNmiqc4ywQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHi8u8ODStqJI7WEiQGe6DMYj/xts8dYSlhIInOFmacv5gJbEDtfqkdPBk/XESWzc
         BIQib24K+YyvzNdMgtzVli17Ya4umn7bEl/J57R6LZOOSMckKuW/iYdifs3DOTpxON
         zDHZXOAxznFdnT35xYv6kTaezKalLjOHoEvFbi0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.17 003/140] ipmi:ipmi_ipmb: Fix null-ptr-deref in ipmi_unregister_smi()
Date:   Tue, 10 May 2022 15:06:33 +0200
Message-Id: <20220510130741.701329627@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

commit 9cc3aac42566a0021e0ab7c4e9b31667ad75b1e3 upstream.

KASAN report null-ptr-deref as follows:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:ipmi_unregister_smi+0x7d/0xd50 drivers/char/ipmi/ipmi_msghandler.c:3680
Call Trace:
 ipmi_ipmb_remove+0x138/0x1a0 drivers/char/ipmi/ipmi_ipmb.c:443
 ipmi_ipmb_probe+0x409/0xda1 drivers/char/ipmi/ipmi_ipmb.c:548
 i2c_device_probe+0x959/0xac0 drivers/i2c/i2c-core-base.c:563
 really_probe+0x3f3/0xa70 drivers/base/dd.c:541

In ipmi_ipmb_probe(), 'iidev->intf' is not set before
ipmi_register_smi() success.  And in the error handling case,
ipmi_ipmb_remove() is called to release resources, ipmi_unregister_smi()
is called without check 'iidev->intf', this will cause KASAN
null-ptr-deref issue.

General kernel style is to allow NULL to be passed into unregister
calls, so fix it that way.  This allows a NULL check to be removed in
other code.

Fixes: 57c9e3c9a374 ("ipmi:ipmi_ipmb: Unregister the SMI on remove")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: stable@vger.kernel.org # v5.17+
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    5 ++++-
 drivers/char/ipmi/ipmi_si_intf.c    |    5 +----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3677,8 +3677,11 @@ static void cleanup_smi_msgs(struct ipmi
 void ipmi_unregister_smi(struct ipmi_smi *intf)
 {
 	struct ipmi_smi_watcher *w;
-	int intf_num = intf->intf_num, index;
+	int intf_num, index;
 
+	if (!intf)
+		return;
+	intf_num = intf->intf_num;
 	mutex_lock(&ipmi_interfaces_mutex);
 	intf->intf_num = -1;
 	intf->in_shutdown = true;
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2220,10 +2220,7 @@ static void cleanup_one_si(struct smi_in
 		return;
 
 	list_del(&smi_info->link);
-
-	if (smi_info->intf)
-		ipmi_unregister_smi(smi_info->intf);
-
+	ipmi_unregister_smi(smi_info->intf);
 	kfree(smi_info);
 }
 


