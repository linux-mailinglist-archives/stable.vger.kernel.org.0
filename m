Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830DC5950ED
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiHPErC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiHPEqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F44176DD2;
        Mon, 15 Aug 2022 13:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A2FB80EAD;
        Mon, 15 Aug 2022 20:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F451C433C1;
        Mon, 15 Aug 2022 20:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596233;
        bh=a8xOtKnYMAkem95yckU2lhi3DlAhwkHOwu0q0nxZIDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yiuW2tpMHk8zLn87XOhAqtSVtje37WvajWRuAHjBNPwCPHcdK+Y0j6qpz6g8vx6xh
         F9t9yh2Wgw6MDNx/u5usw7yOO42rpuQ9A9YHlwn5A7A4pmYDmBtsyH18yKx9C5nQY+
         qKue6ctOCZjsJBeRuLHeWAt2GnFlC7HlYeb3i7r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0971/1157] ASoC: amd: yc: Decrease level of error message
Date:   Mon, 15 Aug 2022 20:05:27 +0200
Message-Id: <20220815180518.543596136@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 393a40b50fe976a121b15752d2dd6151c7a92126 ]

On a number of platforms that contain acp3x controller a new ERR level
message is showing up:

`acp6x pci device not found`

This is because ACP3x and ACP6x share same PCI ID but can be identified
by PCI revision.  As this is expected behavior for a system with ACP3x
decrease message to debug.

Fixes: b1630fcbfde6c ("ASoC: amd: yc: add new YC platform varaint support")
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220718213402.19497-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/pci-acp6x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/pci-acp6x.c b/sound/soc/amd/yc/pci-acp6x.c
index 20f7a99783f2..77c5fa1f7af1 100644
--- a/sound/soc/amd/yc/pci-acp6x.c
+++ b/sound/soc/amd/yc/pci-acp6x.c
@@ -159,7 +159,7 @@ static int snd_acp6x_probe(struct pci_dev *pci,
 	case 0x6f:
 		break;
 	default:
-		dev_err(&pci->dev, "acp6x pci device not found\n");
+		dev_dbg(&pci->dev, "acp6x pci device not found\n");
 		return -ENODEV;
 	}
 	if (pci_enable_device(pci)) {
-- 
2.35.1



