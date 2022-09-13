Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D66F5B7703
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIMRAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiIMQ7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:59:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F798A1EC;
        Tue, 13 Sep 2022 08:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A690B80FAF;
        Tue, 13 Sep 2022 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CB3C433C1;
        Tue, 13 Sep 2022 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079634;
        bh=XXC+a3xq5qAP/usGFnXD3rfC/OQss3BaSL/hh1UlkMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJJyBhn5TZNEDaTUu9hZ4s/V1S9cc+a4msZw+cM1PGt2BBI0jTh1XesC6noDF7aAz
         hbg1/4+Y66GZm0HRTmKM6ikYPPqtCvL2yE1sLwu846qbLOj0JgeD/U3Ht6wxHim+Bl
         T+HIv0QxR5M/TMGVPMSwc4aC0xYnsdqMSvQ1Ylbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/61] Input: rk805-pwrkey - fix module autoloading
Date:   Tue, 13 Sep 2022 16:07:17 +0200
Message-Id: <20220913140347.280518499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 99077ad668ddd9b4823cc8ce3f3c7a3fc56f6fd9 ]

Add the module alias so the rk805-pwrkey driver will
autoload when built as a module.

Fixes: 5a35b85c2d92 ("Input: add power key driver for Rockchip RK805 PMIC")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20220612225437.3628788-1-pbrobinson@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/rk805-pwrkey.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/rk805-pwrkey.c b/drivers/input/misc/rk805-pwrkey.c
index 921003963a53c..cdcad5c01e3c0 100644
--- a/drivers/input/misc/rk805-pwrkey.c
+++ b/drivers/input/misc/rk805-pwrkey.c
@@ -106,6 +106,7 @@ static struct platform_driver rk805_pwrkey_driver = {
 };
 module_platform_driver(rk805_pwrkey_driver);
 
+MODULE_ALIAS("platform:rk805-pwrkey");
 MODULE_AUTHOR("Joseph Chen <chenjh@rock-chips.com>");
 MODULE_DESCRIPTION("RK805 PMIC Power Key driver");
 MODULE_LICENSE("GPL");
-- 
2.35.1



