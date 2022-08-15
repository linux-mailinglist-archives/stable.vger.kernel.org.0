Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7AD5938F3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbiHOSr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbiHOSqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED7841D01;
        Mon, 15 Aug 2022 11:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F1160FBA;
        Mon, 15 Aug 2022 18:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D203AC433D7;
        Mon, 15 Aug 2022 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588102;
        bh=9fFU841hpe5Pyc79KUrqRFYYT/dlO83nB9lU2JYsXWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz1HGcAky8HTi81egvG5nfYaXEuU94j7M5D5n3sgBGifs/ksVk8PWo875GZPYWeuY
         HH3NLl5pl0qUqVio7p90pU/ZSUnfNt+/ybUTYV5yR2yC8ECuNwaeWcqKiafNz+DTCT
         sZuXDgEKQGigFCHYTNGp/OMizU3+E6bBbCBytj8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/779] i2c: Fix a potential use after free
Date:   Mon, 15 Aug 2022 19:58:28 +0200
Message-Id: <20220815180348.650294076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit e4c72c06c367758a14f227c847f9d623f1994ecf ]

Free the adap structure only after we are done using it.
This patch just moves the put_device() down a bit to avoid the
use after free.

Fixes: 611e12ea0f12 ("i2c: core: manage i2c bus device refcount in i2c_[get|put]_adapter")
Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
[wsa: added comment to the code, added Fixes tag]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index cfbef70e8ba7..8fb065caf30b 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2464,8 +2464,9 @@ void i2c_put_adapter(struct i2c_adapter *adap)
 	if (!adap)
 		return;
 
-	put_device(&adap->dev);
 	module_put(adap->owner);
+	/* Should be last, otherwise we risk use-after-free with 'adap' */
+	put_device(&adap->dev);
 }
 EXPORT_SYMBOL(i2c_put_adapter);
 
-- 
2.35.1



