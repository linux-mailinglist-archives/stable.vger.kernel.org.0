Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA145EA17A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiIZKvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiIZKuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9292A58B75;
        Mon, 26 Sep 2022 03:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 309F5CE10E7;
        Mon, 26 Sep 2022 10:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4363AC433C1;
        Mon, 26 Sep 2022 10:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188035;
        bh=GWa16rvj/h5sa52LnyTpHLgpKiLjXnpuNgp3x4Unlck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8CO84TvbiFJ8cvPNK8JxRPbAlBePNgJot2B+zQwGvnUYS6WAFIFsbfL5kpMQBFz6
         ioYWujMumsXYSZKt2XOGVXfldeMp+QRHne8lzyic2HhBIGOnjpDRilSNhr7QHgUc3x
         lFQ20eSKY0RAwHPMlEISPgJk0TemJRpqtW2Apkwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Ju Zhou <PengJu.Zhou@amd.com>,
        "Emily.Deng" <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/141] drm/amdgpu: indirect register access for nv12 sriov
Date:   Mon, 26 Sep 2022 12:10:28 +0200
Message-Id: <20220926100754.716915662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Ju Zhou <PengJu.Zhou@amd.com>

[ Upstream commit 8b8a162da820d48bb94261ae4684f2c839ce148c ]

unify host driver and guest driver indirect access
control bits names

Signed-off-by: Peng Ju Zhou <PengJu.Zhou@amd.com>
Reviewed-by: Emily.Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 5 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index f262c4e7a48a..a5f9f51cf583 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2047,6 +2047,11 @@ static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 				amdgpu_vf_error_put(adev, AMDGIM_ERROR_VF_ATOMBIOS_INIT_FAIL, 0, 0);
 				return r;
 			}
+
+			/*get pf2vf msg info at it's earliest time*/
+			if (amdgpu_sriov_vf(adev))
+				amdgpu_virt_init_data_exchange(adev);
+
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index e7678ba8fdcf..d17bd0140bf6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -615,6 +615,14 @@ void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 				if (adev->virt.ras_init_done)
 					amdgpu_virt_add_bad_page(adev, bp_block_offset, bp_block_size);
 			}
+	} else if (adev->bios != NULL) {
+		adev->virt.fw_reserve.p_pf2vf =
+			(struct amd_sriov_msg_pf2vf_info_header *)
+			(adev->bios + (AMD_SRIOV_MSG_PF2VF_OFFSET_KB << 10));
+
+		amdgpu_virt_read_pf2vf_data(adev);
+
+		return;
 	}
 
 	if (adev->virt.vf2pf_update_interval_ms != 0) {
-- 
2.35.1



