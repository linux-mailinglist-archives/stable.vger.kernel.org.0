Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9555947B8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbiHOX3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344645AbiHOX00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B480538;
        Mon, 15 Aug 2022 13:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A27B80EA8;
        Mon, 15 Aug 2022 20:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788FFC433D7;
        Mon, 15 Aug 2022 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594009;
        bh=gCasWjXfyVMddZoYuo5MwQA3iAWTIDwFsCXYGZBFCo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4tq7Xe+zfBeroVhNnJO8zpm70A8MgMeFICbrTHINPPFN5JOPcfnLmL5G4exxr3oN
         Hb5ZcpYyO4KznZL2jrJKxWiPta6i7VAOnj6v9AEI3rDDHGsLs75Gguffe0zfAdR0cK
         N6C5LBxVPaO5/tyHzcZ1z6giY2uVnOeqPM0PN4F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0361/1157] i2c: Fix a potential use after free
Date:   Mon, 15 Aug 2022 19:55:17 +0200
Message-Id: <20220815180454.153000538@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index d43db2c3876e..19a317fdcf5b 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2467,8 +2467,9 @@ void i2c_put_adapter(struct i2c_adapter *adap)
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



