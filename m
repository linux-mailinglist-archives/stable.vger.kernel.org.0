Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4E4B4A7A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347683AbiBNKbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348114AbiBNKaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511169BF59;
        Mon, 14 Feb 2022 01:59:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D347760921;
        Mon, 14 Feb 2022 09:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ADEC340E9;
        Mon, 14 Feb 2022 09:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832757;
        bh=QUTNVwz+yVHcljh6bmE8p4c9DR9JYaIcZoW8VimMowk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbbT5LjaKP8tVo2f5y5eDjga3J39Sb1+HhpgVR/Oxp99qM9PR/hju42F1SXEnodl+
         G4RsRGndicu2DwOED+dK7rUz/zo8gOnezpO805ssTi28fL3RO8NgMJYwObylsMi2Og
         C3IndlSZH/zNJI9TtdFDTgWwiTpqos6kDw865I14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 107/203] arm64: Enable Cortex-A510 erratum 2051678 by default
Date:   Mon, 14 Feb 2022 10:25:51 +0100
Message-Id: <20220214092513.882562722@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a4b92cebc31d49b7e6ef0ce584c7f2a2e112877d ]

The recently added configuration option for Cortex A510 erratum 2051678 does
not have a "default y" unlike other errata fixes. This appears to simply be
an oversight since the help text suggests enabling the option if unsure and
there's nothing in the commit log to suggest it is intentional.

Fixes: 297ae1eb23b0 ("arm64: cpufeature: List early Cortex-A510 parts as having broken dbm")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220201144838.20037-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38e7f19df14d4..ae0e93871ee5f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -672,6 +672,7 @@ config ARM64_WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 
 config ARM64_ERRATUM_2051678
 	bool "Cortex-A510: 2051678: disable Hardware Update of the page table dirty bit"
+	default y
 	help
 	  This options adds the workaround for ARM Cortex-A510 erratum ARM64_ERRATUM_2051678.
 	  Affected Coretex-A510 might not respect the ordering rules for
-- 
2.34.1



