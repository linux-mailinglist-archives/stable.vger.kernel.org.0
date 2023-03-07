Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4846A6AF2AF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjCGSzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjCGSys (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:54:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1255BAF29F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:42:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB406152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9720AC433D2;
        Tue,  7 Mar 2023 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214527;
        bh=v5ljIiQWZBHCGZvt3PnAC5FrftRBxOoDU6VDJZi+kH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYlTbyveFn5f3mgILOHvARZlE4yguHEvaSykCu58u9PqXctYuSSUJfYa/j7dYZ1Ws
         8J52fLxaDA2X0+ZkMo1QePE82uPC/FPee8A/ySYz4rOT7xIKpJA/E07eWBFuwH7n27
         AJxGty0W+H9XbLYxRaeNDJGofOt4Mzx85b3sMM9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ding Hui <dinghui@sangfor.com.cn>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 851/885] scsi: ses: Dont attach if enclosure has no components
Date:   Tue,  7 Mar 2023 18:03:05 +0100
Message-Id: <20230307170038.762634983@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <jejb@linux.ibm.com>

commit 3fe97ff3d94934649abb0652028dd7296170c8d0 upstream.

An enclosure with no components can't usefully be operated by the driver
(since effectively it has nothing to manage), so report the problem and
don't attach. Not attaching also fixes an oops which could occur if the
driver tries to manage a zero component enclosure.

[mkp: Switched to KERN_WARNING since this scenario is common]

Link: https://lore.kernel.org/r/c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com
Cc: stable@vger.kernel.org
Reported-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -704,6 +704,12 @@ static int ses_intf_add(struct device *c
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+
+	if (components == 0) {
+		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
+		goto err_free;
+	}
+
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;


