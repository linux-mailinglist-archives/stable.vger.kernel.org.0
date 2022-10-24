Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D70560AC78
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJXOHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiJXOFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A278CE2A;
        Mon, 24 Oct 2022 05:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13EFF61298;
        Mon, 24 Oct 2022 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B1AC433D6;
        Mon, 24 Oct 2022 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615814;
        bh=LQmAsakAOhTVeU7uBGJsnSq11BNJSXfSrfG52Xu9Yu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bbeyo9LKGz9TfidHbpU9m7rpJmd1aJIOsDrylh2LbgPdx8YZMIoxWK9u7de4V9+Sl
         dHTVJYU1uFu19IiyGRP/9gADux8daaCzxqIHsgwp3Pcckyrbu4D+JgEEmLNHPs7/44
         SRlkgGA7iQxvcLbb1VINrmyOOBLHHNxvUswS1BGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 362/530] powerpc/configs: Properly enable PAPR_SCM in pseries_defconfig
Date:   Mon, 24 Oct 2022 13:31:46 +0200
Message-Id: <20221024113101.443301734@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit aa398d88aea4ec863bd7aea35d5035a37096dc59 ]

My commit to add PAPR_SCM to pseries_defconfig failed to add the
required dependencies, meaning the driver doesn't get built.

Add the required LIBNVDIMM=m.

Fixes: d6481a7195df ("powerpc/configs: Add PAPR_SCM to pseries_defconfig")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220901014253.252927-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/pseries_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index d0494fbb4961..6011977d43c9 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -41,6 +41,7 @@ CONFIG_DTL=y
 CONFIG_SCANLOG=m
 CONFIG_PPC_SMLPAR=y
 CONFIG_IBMEBUS=y
+CONFIG_LIBNVDIMM=m
 CONFIG_PAPR_SCM=m
 CONFIG_PPC_SVM=y
 # CONFIG_PPC_PMAC is not set
-- 
2.35.1



