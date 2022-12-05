Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFCD643307
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiLETdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiLETdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869252D1D7
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D6961309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FD2C43470;
        Mon,  5 Dec 2022 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268497;
        bh=AY8eTK85itzhck97ybvAxHzCI4Ah9j0w5stfPlhKits=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqWtLQLvrosH6i+tJbSTVuk0FdLpf1EQEcSrqOYMQe5wIGrtEk70GjEsSOrBr6lC9
         4YOp7hLkzw0vbFDW/kkr2T4uP+KBP+QmOFpCaaJ5cHFsU625g3l04p6k/ffbzHTaSU
         RDGf6ep9H922ezlXqPmvrsP6/z7XTcho2qJ1mwhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Leo Liu <leo.liu@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 095/124] drm/amdgpu: enable Vangogh VCN indirect sram mode
Date:   Mon,  5 Dec 2022 20:10:01 +0100
Message-Id: <20221205190811.114493866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Leo Liu <leo.liu@amd.com>

commit 9a8cc8cabc1e351614fd7f9e774757a5143b6fe8 upstream.

So that uses PSP to initialize HW.

Fixes: 0c2c02b66c672e ("drm/amdgpu/vcn: add firmware support for dimgrey_cavefish")
Signed-off-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -156,6 +156,9 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 		break;
 	case IP_VERSION(3, 0, 2):
 		fw_name = FIRMWARE_VANGOGH;
+		if ((adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) &&
+		    (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
+			adev->vcn.indirect_sram = true;
 		break;
 	case IP_VERSION(3, 0, 16):
 		fw_name = FIRMWARE_DIMGREY_CAVEFISH;


