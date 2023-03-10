Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5786B449D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjCJO0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjCJOZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:25:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0088118BFE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:24:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FDF8617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85854C433EF;
        Fri, 10 Mar 2023 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458278;
        bh=SRrMPsZV/fDWB+ShBM3M7dPJV0CxppKyHVEJZfHNL0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vktMUf0fW3zcWxvouM2YSa+wHT5e2f0OLVYbNImGrkBONHcTPcTUCOjwaqcLWW2zT
         puNX4z/SU6ft5wVJLZyOzI8Hq7rnCJzYO50qCXhbWWJx/mOUsmlm3rAt7O15gar6kc
         47vboYWRhYq/2r4562LQyMX2e4yLxKvlM0QCHE7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 192/252] scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()
Date:   Fri, 10 Mar 2023 14:39:22 +0100
Message-Id: <20230310133724.767735634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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

From: Tomas Henzl <thenzl@redhat.com>

commit 578797f0c8cbc2e3ec5fc0dab87087b4c7073686 upstream.

A fix for:

BUG: KASAN: slab-out-of-bounds in ses_intf_remove+0x23f/0x270 [ses]
Read of size 8 at addr ffff88a10d32e5d8 by task rmmod/12013

When edev->components is zero, accessing edev->component[0] members is
wrong.

Link: https://lore.kernel.org/r/20230202162451.15346-5-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -872,7 +872,8 @@ static void ses_intf_remove_enclosure(st
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);


