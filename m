Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB8B6AEA96
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjCGRfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjCGReu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF511A2F0F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 621B161517
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865AC4339B;
        Tue,  7 Mar 2023 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210257;
        bh=TKa6nft5aMk4gVFZO0PgfnEPhVn9SKKaJGyONJLl6lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enzH0IuIbxkzbCSYfrMrAOSHaSQ0ruz3bfriVno1Qp8Or6sOK+MVaDZO3F9lWrpVz
         3F60rW0AgGI+p8koWjfA1ydo1w6DztEq5KR4tPIT5EPjS7pOdAp8kFOQ7wcAcv90fo
         5Sc4Ruo3NGg48lgspNpHjOxqgs0D+/yc1TsFcwQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Fitzhenry <tom@tom-fitzhenry.me.uk>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0483/1001] mfd: rk808: Re-add rk808-clkout to RK818
Date:   Tue,  7 Mar 2023 17:54:15 +0100
Message-Id: <20230307170042.360109198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Fitzhenry <tom@tom-fitzhenry.me.uk>

[ Upstream commit 5d69b181cd0db10dc8327d28ce837b3623cd531a ]

Fixes RK818 (e.g. on Pinephone Pro) to register its clock, without which
dependent devices (e.g. wifi/BT, via sdio-wifi-pwrseq) fail to probe.

This line was removed in commit 3633daacea2e
("mfd: rk808: Permit having multiple PMIC instances"), but only from RK818.

Fixes: 3633daacea2e ("mfd: rk808: Permit having multiple PMIC instances")
Signed-off-by: Tom Fitzhenry <tom@tom-fitzhenry.me.uk>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230102111147.2580861-1-tom@tom-fitzhenry.me.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/rk808.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
index f44fc3f080a8e..0f22ef61e8170 100644
--- a/drivers/mfd/rk808.c
+++ b/drivers/mfd/rk808.c
@@ -189,6 +189,7 @@ static const struct mfd_cell rk817s[] = {
 };
 
 static const struct mfd_cell rk818s[] = {
+	{ .name = "rk808-clkout", .id = PLATFORM_DEVID_NONE, },
 	{ .name = "rk808-regulator", .id = PLATFORM_DEVID_NONE, },
 	{
 		.name = "rk808-rtc",
-- 
2.39.2



