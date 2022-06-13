Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6595483E6
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbiFMKOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbiFMKOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:14:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D4388E;
        Mon, 13 Jun 2022 03:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94DB4CE1164;
        Mon, 13 Jun 2022 10:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535C4C36B09;
        Mon, 13 Jun 2022 10:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115269;
        bh=493NnMb0m3jXFaC9Qo/ThcPB1+4sJ7bhd1oanoqWjbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQ+eRmZBy0ptWYiqAXhVLZOHWEsCEGdC6AIpBbO+FUCKDOq0BBw9VpzQOMVnif9Ws
         uWYZRPD8TQBn5VReihjwOeN0vSBRGYUSwFsIyU45vI3V+2IOrlLieIl8l2uySWEv6M
         HRKGmL+UoKzEbVAqWBhN9OdUmt2JQdmJUGt0ug7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 015/167] scsi: megaraid: Fix error check return value of register_chrdev()
Date:   Mon, 13 Jun 2022 12:08:09 +0200
Message-Id: <20220613094844.444248570@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit c5acd61dbb32b6bda0f3a354108f2b8dcb788985 ]

If major equals 0, register_chrdev() returns an error code when it fails.
This function dynamically allocates a major and returns its number on
success, so we should use "< 0" to check it instead of "!".

Link: https://lore.kernel.org/r/20220418105755.2558828-1-lv.ruyi@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 2cbfec6a7466..2f7132edcd3f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4705,7 +4705,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
-- 
2.35.1



