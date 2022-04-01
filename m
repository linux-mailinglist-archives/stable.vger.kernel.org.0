Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8B4EF4DE
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348970AbiDAPEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349429AbiDAOzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951A265816;
        Fri,  1 Apr 2022 07:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AF05B8240E;
        Fri,  1 Apr 2022 14:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB8CC34113;
        Fri,  1 Apr 2022 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824228;
        bh=Qo0QuXOTAUSojoSYUM3ShTjaFRA1mLkuZiHLouEKk7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaAl+HV3rEBzTcAyP6vTw5AKWE4YQeDzmEqNQIBgCJdFJyjCEZhWbAMFd6abKIiyy
         ngN2CZ6//WgN1qHtRX62JpnxvOvjeLK8htPJcFRoXDDujTSZj96qfQ/HRXR1zEDWk+
         kjqi5AI9WzRY3oTs++JDwGp1KX//r+fZCxv400N9+4ss+CSR0Ofo7PZ98jYsAxBMKD
         TV8v/p7VRJWZq9Vkmd352T2yVoIR0Ms6f3LvlFWjPfzwC1i20VMACSgU521mLZwCB7
         NGfb5gxU99JwlWT0MNfFaQIjQbZZHcYOJoMpbPLXVg8pgmHJQbmg5ZtuZzHKZbd0sV
         c25lI3pEkvWsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/65] scsi: aha152x: Fix aha152x_setup() __setup handler return value
Date:   Fri,  1 Apr 2022 10:41:40 -0400
Message-Id: <20220401144206.1953700-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d8e19afa7a14..c6607c4686bb 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3367,13 +3367,11 @@ static int __init aha152x_setup(char *str)
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
2.34.1

