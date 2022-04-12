Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3194FD051
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347051AbiDLGp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351106AbiDLGoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8091739680;
        Mon, 11 Apr 2022 23:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEC50618FF;
        Tue, 12 Apr 2022 06:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11809C385A1;
        Tue, 12 Apr 2022 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745442;
        bh=47AuPQzkjpr1jstoxI+Yxa3HkE/vCAViYzM51N+Jz+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC7YZpuBggnUer/s7Bip0cVwdIs7mXtiH6mDalAZA0nlJyMVLwixGlW2GOTZtzIr9
         3uMWGLHykvkAVZTY9S1mqpyX6JKtGwejLCLcXJj/WubsAX510pPTyQQpeTsBU4xOcn
         P2mr/PFcLpSHByFV6qvwRP03nKiDp+tr94c7DQFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/171] Revert "hv: utils: add PTP_1588_CLOCK to Kconfig to fix build"
Date:   Tue, 12 Apr 2022 08:29:48 +0200
Message-Id: <20220412062930.692387476@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

This reverts commit c4dc584a2d4c8d74b054f09d67e0a076767bdee5.

On Sat, Apr 09, 2022 at 09:07:51AM -0700, Randy Dunlap wrote:
>According to https://bugzilla.kernel.org/show_bug.cgi?id=215823,
>c4dc584a2d4c8d74b054f09d67e0a076767bdee5 ("hv: utils: add PTP_1588_CLOCK to Kconfig to fix build")
>is a problem for 5.10 since CONFIG_PTP_1588_CLOCK_OPTIONAL does not exist in 5.10.
>This prevents the hyper-V NIC timestamping from working, so please revert that commit.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 210e532ac277..79e5356a737a 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -17,7 +17,6 @@ config HYPERV_TIMER
 config HYPERV_UTILS
 	tristate "Microsoft Hyper-V Utilities driver"
 	depends on HYPERV && CONNECTOR && NLS
-	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Select this option to enable the Hyper-V Utilities.
 
-- 
2.35.1



