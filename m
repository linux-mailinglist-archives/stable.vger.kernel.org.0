Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2163E047
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiK3Sz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiK3SzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0641799F1B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D127B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3DC433D7;
        Wed, 30 Nov 2022 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834522;
        bh=uHHSGPzE4k2K2s3UvoZj95mnjpRNpL1UddUbRSLWg5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3C0yHPIJdVz01TJJV1Tx4sL+3f9ytrWHMcVnQAPysmYG7CgK23y44sfovsKR3ibC
         k4j5LYvvZWxCRJqGBEb47ZlZ3Ue0/06KxzmqfGLDbiNbTR99BA5Sy8Rdv48h7PhnR2
         qFnBPpxTnr8UyPomfUN10+Aerf6Mk6g8P+2pHmsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ramesh Errabolu <Ramesh.Errabolu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 284/289] drm/amdgpu: Enable Aldebaran devices to report CU Occupancy
Date:   Wed, 30 Nov 2022 19:24:29 +0100
Message-Id: <20221130180550.541008982@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Ramesh Errabolu <Ramesh.Errabolu@amd.com>

commit b9ab82da8804ec22c7e91ffd9d56c7a3abff0c8e upstream.

Allow user to know number of compute units (CU) that are in use at any
given moment. Enable access to the method kgd_gfx_v9_get_cu_occupancy
that computes CU occupancy.

Signed-off-by: Ramesh Errabolu <Ramesh.Errabolu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
@@ -41,5 +41,6 @@ const struct kfd2kgd_calls aldebaran_kfd
 	.get_atc_vmid_pasid_mapping_info =
 				kgd_gfx_v9_get_atc_vmid_pasid_mapping_info,
 	.set_vm_context_page_table_base = kgd_gfx_v9_set_vm_context_page_table_base,
+	.get_cu_occupancy = kgd_gfx_v9_get_cu_occupancy,
 	.program_trap_handler_settings = kgd_gfx_v9_program_trap_handler_settings
 };


