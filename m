Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525B84FD619
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355782AbiDLH3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354451AbiDLHRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7694D1123;
        Mon, 11 Apr 2022 23:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BFD615B9;
        Tue, 12 Apr 2022 06:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D00C385A1;
        Tue, 12 Apr 2022 06:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746756;
        bh=fEaYpuKnP4mDHD7HHYhCWcISb75U1FDjOghhvQZ4igY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVKqgK+hqQ+7O7Zt9TtTfsEiga4urtC3R3rmh49GtVX14k4BUAi/DNS11BVyBeW28
         0DzD8bXSAXKEQqnXO6z9fyTEFpM/eprvyZzWXSrqIWsaS+DREKo3jpKfe/F/Hzi0We
         41z7fOSaFNJRZJrE9l46TGow30xRI/SxEAA8FM5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 078/285] scsi: aha152x: Fix aha152x_setup() __setup handler return value
Date:   Tue, 12 Apr 2022 08:28:55 +0200
Message-Id: <20220412062945.915854129@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit cc8294ec4738d25e2bb2d71f7d82a9bf7f4a157b ]

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; doing so just pollutes init's
environment with strings that are not init arguments/parameters).

Return 1 from aha152x_setup() to indicate that the boot option has been
handled.

Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Link: https://lore.kernel.org/r/20220223000623.5920-1-rdunlap@infradead.org
Cc: "Juergen E. Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aha152x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d17880b57d17..2449b4215b32 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3375,13 +3375,11 @@ static int __init aha152x_setup(char *str)
 	setup[setup_count].synchronous = ints[0] >= 6 ? ints[6] : 1;
 	setup[setup_count].delay       = ints[0] >= 7 ? ints[7] : DELAY_DEFAULT;
 	setup[setup_count].ext_trans   = ints[0] >= 8 ? ints[8] : 0;
-	if (ints[0] > 8) {                                                /*}*/
+	if (ints[0] > 8)
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
-	} else {
+	else
 		setup_count++;
-		return 0;
-	}
 
 	return 1;
 }
-- 
2.35.1



