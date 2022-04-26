Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678C050F6BB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345917AbiDZI6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiDZI5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67976256;
        Tue, 26 Apr 2022 01:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410BC60C49;
        Tue, 26 Apr 2022 08:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48747C385A4;
        Tue, 26 Apr 2022 08:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962529;
        bh=GWcUtf3UQVYWNlTxcZ+Z1ItyTx0lhByWckaw0QEi8uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vqkn3rUZo+hcXXqWRT+XPSYA33iswCmRvRkBLQj1EiNlMjweecjBQogJXIP3ROlmG
         vqH2IlVmo5oabd3dWm2YVKnWiqsgkCsvmDjy97q5z1aMXgXhrPTFqTMZcvbsAsvZaJ
         +Q0tiTdnbQYkQUUaHFPBijt5P04cFI8UJmWytemQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/124] Input: omap4-keypad - fix pm_runtime_get_sync() error checking
Date:   Tue, 26 Apr 2022 10:21:28 +0200
Message-Id: <20220426081749.773512486@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 81022a170462d38ea10612cb67e8e2c529d58abe ]

If the device is already in a runtime PM enabled state
pm_runtime_get_sync() will return 1, so a test for negative
value should be used to check for errors.

Fixes: f77621cc640a ("Input: omap-keypad - dynamically handle register offsets")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220412070131.19848-1-linmq006@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/omap4-keypad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index 43375b38ee59..8a7ce41b8c56 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -393,7 +393,7 @@ static int omap4_keypad_probe(struct platform_device *pdev)
 	 * revision register.
 	 */
 	error = pm_runtime_get_sync(dev);
-	if (error) {
+	if (error < 0) {
 		dev_err(dev, "pm_runtime_get_sync() failed\n");
 		pm_runtime_put_noidle(dev);
 		return error;
-- 
2.35.1



