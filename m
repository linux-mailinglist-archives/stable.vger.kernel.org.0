Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63FD59D9F3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352009AbiHWKEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352443AbiHWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E417C1A1;
        Tue, 23 Aug 2022 01:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1639B81C67;
        Tue, 23 Aug 2022 08:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D838CC433C1;
        Tue, 23 Aug 2022 08:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243961;
        bh=b5WWhPm4tN/qjLDw8OdQq86f6/et3lf3Vl+6V9cC7do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpUbZmK/86AM36yZQwWdagXFTMpxbRqHHYejbPFztj5rMAJSfijxk9KXgkjRpKulQ
         2l6iNyImSvBCV8BeWvi8lPTPYeOfG44N242ew13zun77V+fRxTStNF2tEp/XgXonBf
         Mvfxo0ILT+GLEvHqGVJ3lkwGGUgF3DM9wuNO+67Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/229] i2c: Fix a potential use after free
Date:   Tue, 23 Aug 2022 10:23:43 +0200
Message-Id: <20220823080055.953083003@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index b7fe8075f2b8..c1fc49365189 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2243,8 +2243,9 @@ void i2c_put_adapter(struct i2c_adapter *adap)
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



