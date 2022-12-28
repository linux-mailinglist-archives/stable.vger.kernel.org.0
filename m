Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A686581D0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiL1QcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiL1Qbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BF611A3F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200DFB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9B6C433D2;
        Wed, 28 Dec 2022 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244862;
        bh=Jq4TugW0ehcG+e8BFXTH5sEl3zKGdIwI+FWeE6BJRys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nn/FEkIx2kF/83ZQDtuznCowqaPDXCK/xyqAuHY9eynosyX6xdXa3XS/nFfzAcwnU
         UcaYinaHHXsshRny4ciAEoP/eZcCXFmaFjBqKWdGSV3KRy5yW/LkXiQQaRa3SiQopY
         axZZLofN1xNTkcSXYv5wBqY9EkbBqFzQKazv3lSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0712/1146] serial: sunsab: Fix error handling in sunsab_init()
Date:   Wed, 28 Dec 2022 15:37:31 +0100
Message-Id: <20221228144349.484302601@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 1a6ec673fb627c26e2267ca0a03849f91dbd9b40 ]

The sunsab_init() returns the platform_driver_register() directly without
checking its return value, if platform_driver_register() failed, the
allocated sunsab_ports is leaked.
Fix by free sunsab_ports and set it to NULL when platform_driver_register()
failed.

Fixes: c4d37215a824 ("[SERIAL] sunsab: Convert to of_driver framework.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221123061212.52593-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sunsab.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 99608b2a2b74..7ace3aa49840 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -1133,7 +1133,13 @@ static int __init sunsab_init(void)
 		}
 	}
 
-	return platform_driver_register(&sab_driver);
+	err = platform_driver_register(&sab_driver);
+	if (err) {
+		kfree(sunsab_ports);
+		sunsab_ports = NULL;
+	}
+
+	return err;
 }
 
 static void __exit sunsab_exit(void)
-- 
2.35.1



