Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABAD5FCF94
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJMATy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJMATI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:19:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF70E6F78;
        Wed, 12 Oct 2022 17:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0126616CB;
        Thu, 13 Oct 2022 00:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C6C433C1;
        Thu, 13 Oct 2022 00:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620236;
        bh=fSjG4RXvpX46fKNLE6mDdtR1CXfA7oy7Me+/3xuP4Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnpa5V1/2XLZM18qpl2RHuX14Cuyc7ytMQrKD4VG9Dnhsg3MWoumv6JumApa3z8jp
         cCNQL5Aiq/p9cbvxUpTdFDOC7BUZ6P+ipMAwKfsz0Fkg5/KOGKMQg4/TeOaBIouBNX
         Ct5eu9831V/s52OdrydyYNGwD1KQvk83dT3IBcv0puFW1lMtelLN8OVAF99O0b71xm
         VkvwdWuRc6FtOIIjU5x1eF+KABk45r0IZCU9S7qbd9K8vHy+GjAbrdLHBtWTf22Eoa
         mwLrRymhyW/+h+yrznAFx9le5ZCcnPV584fiQN3oCRPpxSfyYJ65gOTm1fv4xbJ4Ug
         l6Cs8Cyf878xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org,
        wangqing@vivo.com, kuba@kernel.org
Subject: [PATCH AUTOSEL 6.0 33/67] HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()
Date:   Wed, 12 Oct 2022 20:15:14 -0400
Message-Id: <20221013001554.1892206-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit b28dbcb379e6a7f80262c2732a57681b1ee548ca ]

ssip_pn_open() claims the HSI client's port with hsi_claim_port(). When
hsi_register_port_event() gets some error and returns a negetive value,
the HSI client's port should be released with hsi_release_port().

Fix it by calling hsi_release_port() when hsi_register_port_event() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/clients/ssi_protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 21f11a5b965b..49ffd808d17f 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -931,6 +931,7 @@ static int ssip_pn_open(struct net_device *dev)
 	if (err < 0) {
 		dev_err(&cl->device, "Register HSI port event failed (%d)\n",
 			err);
+		hsi_release_port(cl);
 		return err;
 	}
 	dev_dbg(&cl->device, "Configuring SSI port\n");
-- 
2.35.1

