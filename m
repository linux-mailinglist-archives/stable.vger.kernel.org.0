Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8360869CC2B
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjBTNhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjBTNhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:37:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13431A640
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:37:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF84B80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2DEC433EF;
        Mon, 20 Feb 2023 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900263;
        bh=PPj5LZH3H2l6zKUToBmv9ZsIyOVMgbIY5lIAeVGaAfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHkYP81BIvQNLQe7hY2msSQOY+eBrdhuvwGIum3hULHPrUmneQHTakM86OM4uR6hX
         TUJ0leoQKAEQWnRb6O6OMaXnY4Y5tAt99deXt+4Rf9w8fHTrPVPKx4OdFWKWLw5z8v
         alqo8Iig27UKWc5ZvAOzFNOa+8M/WgfseomRBO9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.14 13/53] watchdog: diag288_wdt: do not use stack buffers for hardware data
Date:   Mon, 20 Feb 2023 14:35:39 +0100
Message-Id: <20230220133548.646937427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit fe8973a3ad0905cb9ba2d42db42ed51de14737df upstream.

With CONFIG_VMAP_STACK=y the stack is allocated from the vmalloc space.
Data passed to a hardware or a hypervisor interface that
requires V=R can no longer be allocated on the stack.

Use kmalloc() to get memory for a diag288 command.

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/diag288_wdt.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -274,12 +274,21 @@ static int __init diag288_init(void)
 	char ebc_begin[] = {
 		194, 197, 199, 201, 213
 	};
+	char *ebc_cmd;
 
 	watchdog_set_nowayout(&wdt_dev, nowayout_info);
 
 	if (MACHINE_IS_VM) {
-		if (__diag288_vm(WDT_FUNC_INIT, 15,
-				 ebc_begin, sizeof(ebc_begin)) != 0) {
+		ebc_cmd = kmalloc(sizeof(ebc_begin), GFP_KERNEL);
+		if (!ebc_cmd) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -ENOMEM;
+		}
+		memcpy(ebc_cmd, ebc_begin, sizeof(ebc_begin));
+		ret = __diag288_vm(WDT_FUNC_INIT, 15,
+				   ebc_cmd, sizeof(ebc_begin));
+		kfree(ebc_cmd);
+		if (ret != 0) {
 			pr_err("The watchdog cannot be initialized\n");
 			return -EINVAL;
 		}


