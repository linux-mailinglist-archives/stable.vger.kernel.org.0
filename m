Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15174635892
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiKWKAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiKWKAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1763156
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF5FE61B91
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3160C433D6;
        Wed, 23 Nov 2022 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197175;
        bh=tgiFrDg80n7pchFRlTLleiEpeuGunCWBtwQtH9ZZP4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhydL2O3lFsCoZOJONk+ZVD21qMab0WfNPJcMao3w74tthyW4Odh7a7pruYtRE0Cf
         2LPXCJPTlX5BxJJjDtFhXcy0UpiubFAamOoXEQrWc08zky4c7Sx6N/8wsFfUIo8O7y
         dY0ECU/gSbuct2EsoQiNoOk4jc03InmVjdTm8Tiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Lei <Jun.Lei@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Dillon Varone <Dillon.Varone@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 220/314] drm/amd/display: Fix prefetch calculations for dcn32
Date:   Wed, 23 Nov 2022 09:51:05 +0100
Message-Id: <20221123084635.508652842@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

commit 246e667079e8d0fc85f842bceca8c5a3c5da5905 upstream.

[Description]
Prefetch calculation loop was not exiting until utilizing all of vstartup if it
failed once.  Locals need to be reset on each iteration of the loop.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -718,6 +718,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleep
 
 	do {
 		MaxTotalRDBandwidth = 0;
+		DestinationLineTimesForPrefetchLessThan2 = false;
+		VRatioPrefetchMoreThanMax = false;
 #ifdef __DML_VBA_DEBUG__
 		dml_print("DML::%s: Start loop: VStartup = %d\n", __func__, mode_lib->vba.VStartupLines);
 #endif


