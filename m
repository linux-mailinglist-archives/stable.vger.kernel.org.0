Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0970F4F2DBA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbiDEJQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245004AbiDEIxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4841C211;
        Tue,  5 Apr 2022 01:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D30B060FFB;
        Tue,  5 Apr 2022 08:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CA1C385A0;
        Tue,  5 Apr 2022 08:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148548;
        bh=LG0B36g9ZWWMdeW/WzkjNVZ5NcrqZuW9Ts6j3rxaxdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fn+PrGN0lSfcdsOAxUlcDZGec2lYCb7P1qO/iLM/gcf2hJKiEPRYnGfqB763ljLIe
         ujn6kryChGA14HDrTG6BifUDfQIiMskiBIx/LzoeiEWo0sLPNyObuGjFEoEM/qxgpg
         /nHRNdzvaWbqEldVHSUPkFyZTgFqgD5oBxdidm1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0396/1017] ARM: configs: multi_v5_defconfig: re-enable CONFIG_V4L_PLATFORM_DRIVERS
Date:   Tue,  5 Apr 2022 09:21:49 +0200
Message-Id: <20220405070406.040364622@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit f5eb04d7a0e419d61f784de3ced708259ddb71d7 ]

Commit 06b93644f4d1 ("media: Kconfig: add an option to filter in/out
platform drivers") introduced CONFIG_MEDIA_PLATFORM_SUPPORT, to allow
more fine grained control over the inclusion of certain Kconfig files.
multi_v5_defconfig was selecting some drivers described in
drivers/media/platform/Kconfig, which now wasn't included anymore.

Explicitly set the new symbol in multi_v5_defconfig to bring those
drivers back.
This enables some new V4L2 and VIDEOBUF2 features, but as modules only.

Fixes: 06b93644f4d1 ("media: Kconfig: add an option to filter in/out platform drivers")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20220317183043.948432-3-andre.przywara@arm.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/multi_v5_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
index fe8d760256a4..dac1db2e181f 100644
--- a/arch/arm/configs/multi_v5_defconfig
+++ b/arch/arm/configs/multi_v5_defconfig
@@ -188,6 +188,7 @@ CONFIG_REGULATOR=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_MEDIA_PLATFORM_SUPPORT=y
 CONFIG_V4L_PLATFORM_DRIVERS=y
 CONFIG_VIDEO_ASPEED=m
 CONFIG_VIDEO_ATMEL_ISI=m
-- 
2.34.1



