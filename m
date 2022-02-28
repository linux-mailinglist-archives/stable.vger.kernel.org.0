Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B326B4C75E3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiB1R4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiB1RzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:55:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A5F2459E;
        Mon, 28 Feb 2022 09:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37343B81085;
        Mon, 28 Feb 2022 17:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F93C36AEA;
        Mon, 28 Feb 2022 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070272;
        bh=zMGA4gTIdGdhdcERmCkpemte6p3KrE72mw8Fs2CsqBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1k7UB9GNriA6JXfRtAFT36YILPxxOPteJbOMbUir/8F2oCuYqRawfj8DYjzzMP6/K
         XlmilpoU8v14KUdkiL3v858DbnZWEl26Y3m0VDVH1ahrda2NKM307B5ULiEDlzzC+T
         MsNgwIBGbuQGxuzMHqSF2zlAHvhvaObKsL4h+Pc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Gong <curry.gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.16 021/164] drm/amdgpu: do not enable asic reset for raven2
Date:   Mon, 28 Feb 2022 18:23:03 +0100
Message-Id: <20220228172401.949310843@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Gong <curry.gong@amd.com>

commit 1e2be869c8a7247a7253ef4f461f85e2f5931b95 upstream.

The GPU reset function of raven2 is not maintained or tested, so it should be
very unstable.

Now the amdgpu_asic_reset function is added to amdgpu_pmops_suspend, which
causes the S3 test of raven2 to fail, so the asic_reset of raven2 is ignored
here.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Signed-off-by: Chen Gong <curry.gong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -619,8 +619,8 @@ soc15_asic_reset_method(struct amdgpu_de
 static int soc15_asic_reset(struct amdgpu_device *adev)
 {
 	/* original raven doesn't have full asic reset */
-	if ((adev->apu_flags & AMD_APU_IS_RAVEN) &&
-	    !(adev->apu_flags & AMD_APU_IS_RAVEN2))
+	if ((adev->apu_flags & AMD_APU_IS_RAVEN) ||
+	    (adev->apu_flags & AMD_APU_IS_RAVEN2))
 		return 0;
 
 	switch (soc15_asic_reset_method(adev)) {


