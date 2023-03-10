Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5ADE6B460E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjCJOjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjCJOjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD0611AC82
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AA90B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66B5C433A0;
        Fri, 10 Mar 2023 14:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459169;
        bh=v5ljIiQWZBHCGZvt3PnAC5FrftRBxOoDU6VDJZi+kH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awdxVY/tA7V1xN2f2+jZfigSOci2tqBjDgJdpkNWyKjykYWHyzXoshQtFGDo7XWS1
         8AWvXf+EwW8Q+qtyvbSLPyl4YUgorz/aNnvsBcL4ThHDDLVzm9P9KtUnqA+8IWWAUJ
         xDZeMCYqRWHdS5xjZ9Pcn0Vscth/L2hFZBHirzP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ding Hui <dinghui@sangfor.com.cn>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 271/357] scsi: ses: Dont attach if enclosure has no components
Date:   Fri, 10 Mar 2023 14:39:20 +0100
Message-Id: <20230310133746.699821057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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


