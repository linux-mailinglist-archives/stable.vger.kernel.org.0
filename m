Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D054FD1E1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbiDLHIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351474AbiDLHD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:03:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3DF4476E;
        Mon, 11 Apr 2022 23:47:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CAD6B81B35;
        Tue, 12 Apr 2022 06:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A8C385A1;
        Tue, 12 Apr 2022 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746027;
        bh=FxnJlWvCMiH6AOU1ai6/50N28XVk8ZHLjBB2BHX3AgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cN7CXKfGfRvE7RrE/RXez/bXAqtWJJpdyhubsG0yMvFoEsRalXt+vi9J97mM4oThP
         yWUv0BTf9g5AbbmFnOeuGK/n/9gmdSdhlA/cC0tSAxyOup76K8VrBso1yDbGVoiH1g
         HbSo0kyW2XY7upEkaxwCapMJ4no0EWOWdSVbc3rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/277] net: sfp: add 2500base-X quirk for Lantech SFP module
Date:   Tue, 12 Apr 2022 08:28:20 +0200
Message-Id: <20220412062944.850415606@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit 00eec9fe4f3b9588b4bfa8ef9dd0aae96407d5d7 ]

The Lantech 8330-262D-E module is 2500base-X capable, but it reports the
nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
module.

The following in an EEPROM dump of such a SFP with the serial number
redacted:

00: 03 04 07 00 00 00 01 20 40 0c 05 01 19 00 00 00    ???...? @????...
10: 1e 0f 00 00 4c 61 6e 74 65 63 68 20 20 20 20 20    ??..Lantech
20: 20 20 20 20 00 00 00 00 38 33 33 30 2d 32 36 32        ....8330-262
30: 44 2d 45 20 20 20 20 20 56 31 2e 30 03 52 00 cb    D-E     V1.0?R.?
40: 00 1a 00 00 46 43 XX XX XX XX XX XX XX XX XX XX    .?..FCXXXXXXXXXX
50: 20 20 20 20 32 32 30 32 31 34 20 20 68 b0 01 98        220214  h???
60: 45 58 54 52 45 4d 45 4c 59 20 43 4f 4d 50 41 54    EXTREMELY COMPAT
70: 49 42 4c 45 20 20 20 20 20 20 20 20 20 20 20 20    IBLE

Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20220312205014.4154907-1-michael@walle.cc
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index ef2c6a09eb0f..4369d6249e7b 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -74,6 +74,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// Lantech 8330-262D-E can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "Lantech",
+		.part = "8330-262D-E",
+		.modes = sfp_quirk_2500basex,
 	}, {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
-- 
2.35.1



