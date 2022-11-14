Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC2A627F83
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbiKNNAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiKNNAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3925C7D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C696117F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81E4C433D6;
        Mon, 14 Nov 2022 13:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430801;
        bh=EKK+cQkENJ4wpzTdHj2dvsQi9RXLghP6wWj40bHFOjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwzLwD7n7miF6zED3Qy4dNNLF8tfonUIx/AjnjGJVfVm3MMQKckUjjRlyZUuLOt7M
         o4vHOpYllFe6+FELWQbzP6YPZAHYfmwIzOWcFGs2LAW6l79Fd1ZRbfOT3D5fzImMlC
         JfYG7hKACk+gvmIPmPZCP/uO6QtXzy6NtEHCLhGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guchun Chen <guchun.chen@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 101/131] drm/amdgpu: disable BACO on special BEIGE_GOBY card
Date:   Mon, 14 Nov 2022 13:46:10 +0100
Message-Id: <20221114124452.989878848@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
@@ -366,7 +366,9 @@ static void sienna_cichlid_check_bxco_su
 		if (((adev->pdev->device == 0x73A1) &&
 		    (adev->pdev->revision == 0x00)) ||
 		    ((adev->pdev->device == 0x73BF) &&
-		    (adev->pdev->revision == 0xCF)))
+		    (adev->pdev->revision == 0xCF)) ||
+		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
 	}


