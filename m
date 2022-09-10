Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA65B49A7
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiIJVVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiIJVUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEA74E62B;
        Sat, 10 Sep 2022 14:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC8960C5F;
        Sat, 10 Sep 2022 21:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA53C43140;
        Sat, 10 Sep 2022 21:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844689;
        bh=hMxM1YEIO7UInQ24yBlGre3/fNP2hbA+v0IGhcgNjAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3yRNDbdBej7WcCJlZuorr8l/DK3YmioRQwYh6mWeQ9vAeK2Hcj+A2WFgp099J8lA
         lwyOBLk37/JahHwh1mA2XFtAZNjVdWk+jE0x8KNTr1ngjxVHFc6vj3AZQq4+LzUP0e
         u0kWGcuhsHfn9R5wH9HzM4Ae2HoZImff53LFjsts0QH8gblNZtiVljbo4D6AISKASV
         Xos6yp1KVf1LPD5H5pQWlKdpvdr6b87dQpeOW0/kPG/6skG4HCiEyubvitps5D23Mz
         LqV6oEyRvMXd6TphnUt7TRrl9+4JrpZANJ/Cg+Vyi4eJzNRe8tGzR7za9qomXCyP3S
         YsJJuVy6HNt6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Michael=20H=C3=BCbner?= <michaelh.95@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 09/21] HID: thrustmaster: Add sparco wheel and fix array length
Date:   Sat, 10 Sep 2022 17:17:40 -0400
Message-Id: <20220910211752.70291-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Michael Hübner <michaelh.95@t-online.de>

[ Upstream commit d9a17651f3749e69890db57ca66e677dfee70829 ]

Add device id for the Sparco R383 Mod wheel.

Fix wheel info array length to match actual wheel count present in the array.

Signed-off-by: Michael Hübner <michaelh.95@t-online.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index a28c3e5756506..2221bc26e611a 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -67,12 +67,13 @@ static const struct tm_wheel_info tm_wheels_infos[] = {
 	{0x0200, 0x0005, "Thrustmaster T300RS (Missing Attachment)"},
 	{0x0206, 0x0005, "Thrustmaster T300RS"},
 	{0x0209, 0x0005, "Thrustmaster T300RS (Open Wheel Attachment)"},
+	{0x020a, 0x0005, "Thrustmaster T300RS (Sparco R383 Mod)"},
 	{0x0204, 0x0005, "Thrustmaster T300 Ferrari Alcantara Edition"},
 	{0x0002, 0x0002, "Thrustmaster T500RS"}
 	//{0x0407, 0x0001, "Thrustmaster TMX"}
 };
 
-static const uint8_t tm_wheels_infos_length = 4;
+static const uint8_t tm_wheels_infos_length = 7;
 
 /*
  * This structs contains (in little endian) the response data
-- 
2.35.1

