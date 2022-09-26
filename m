Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620745EA3F8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiIZLhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiIZLgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:36:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B1EB494;
        Mon, 26 Sep 2022 03:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2A69B8095D;
        Mon, 26 Sep 2022 10:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6B2C433C1;
        Mon, 26 Sep 2022 10:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189035;
        bh=FNlNUpO7zOVpbzBzSiXTkd1MoY2CKoYDpVut8xj5Jag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/l1YqAhjNVDGRWH1sS9UtWHTfpxVbcZjhZa/mB+e8miEJ0NCppL+jlbBV/YemA7+
         2+sPo6//AmLY8foA9oT8N+Zj1Pz5X5ZVDbXwAAN5iDTzTqkZ5f5CVDnzg98+DQ+mjr
         M+UBaZT3lHEQJjxof6Ig99cb/kqkPVIusgB8wM6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: [PATCH 5.19 052/207] gpio: mockup: Fix potential resource leakage when register a chip
Date:   Mon, 26 Sep 2022 12:10:41 +0200
Message-Id: <20220926100808.957917375@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 02743c4091ccfb246f5cdbbe3f44b152d5d12933 upstream.

If creation of software node fails, the locally allocated string
array is left unfreed. Free it on error path.

Fixes: 6fda593f3082 ("gpio: mockup: Convert to use software nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mockup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -533,8 +533,10 @@ static int __init gpio_mockup_register_c
 	}
 
 	fwnode = fwnode_create_software_node(properties, NULL);
-	if (IS_ERR(fwnode))
+	if (IS_ERR(fwnode)) {
+		kfree_strarray(line_names, ngpio);
 		return PTR_ERR(fwnode);
+	}
 
 	pdevinfo.name = "gpio-mockup";
 	pdevinfo.id = idx;


