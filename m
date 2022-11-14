Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9776280B1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbiKNNIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbiKNNIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DC92AE12
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9495B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2725EC433D6;
        Mon, 14 Nov 2022 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431288;
        bh=IaPUGVXjOs5jmYWG934kEblEBRfTSDgrZBKIiugopg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhJ1PF29Iu8aEJujCSZVym7IWpsiNB6Tcv8dL63lvJONykQchb3DByMXosE1OmCCW
         z1yGJ7A/gmCyGAsazsNaWvsoAbH5v+lvb58Gnn2CkCsPMKrvF2WuY10n5KeXhMiFxO
         fXAnxdrbXTvO3AUAtSO56sJEJxjfRHHB4CEgGEkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guchun Chen <guchun.chen@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 141/190] drm/amdgpu: disable BACO on special BEIGE_GOBY card
Date:   Mon, 14 Nov 2022 13:46:05 +0100
Message-Id: <20221114124504.958373505@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Guchun Chen <guchun.chen@amd.com>

commit 0c85c067c9d9d7a1b2cc2e01a236d5d0d4a872b5 upstream.

Still avoid intermittent failure.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -376,7 +376,9 @@ static void sienna_cichlid_check_bxco_su
 		if (((adev->pdev->device == 0x73A1) &&
 		    (adev->pdev->revision == 0x00)) ||
 		    ((adev->pdev->device == 0x73BF) &&
-		    (adev->pdev->revision == 0xCF)))
+		    (adev->pdev->revision == 0xCF)) ||
+		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
 	}


