Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF332ABA67
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732422AbgKINSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733005AbgKINSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E5F216C4;
        Mon,  9 Nov 2020 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927929;
        bh=CDVljiW7bCT4cLNhuxkfnAaKqBZj2U/NQDkVfNkVy1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1JKE2BKRvKOTlGKGJ8mKk8YXnttQHeUZ5eJ/qR4aZO6uHPXJWtKnpSIKAdzX0yu/
         qpMT55KAKwTkqtdv/DZHPjHg9HFLFpnVp91ey7z0/v2lL75HL/NuJ6pU7jcrpAPrsX
         SJ1RyMxwHh/hIQXPe9f1IlY4wKBx2Juk/8+pWFFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        John Clements <john.clements@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 062/133] drm/amdgpu: resolved ASD loading issue on sienna
Date:   Mon,  9 Nov 2020 13:55:24 +0100
Message-Id: <20201109125033.715570138@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Clements <john.clements@amd.com>

commit 26f4fd6d87cbf72376ee4f6a9dca1c95a3143563 upstream.

updated fw header v2 parser to set asd fw memory

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: John Clements <john.clements@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2322,6 +2322,7 @@ int parse_ta_bin_descriptor(struct psp_c
 		psp->asd_feature_version   = le32_to_cpu(desc->fw_version);
 		psp->asd_ucode_size 	   = le32_to_cpu(desc->size_bytes);
 		psp->asd_start_addr 	   = ucode_start_addr;
+		psp->asd_fw                = psp->ta_fw;
 		break;
 	case TA_FW_TYPE_PSP_XGMI:
 		psp->ta_xgmi_ucode_version = le32_to_cpu(desc->fw_version);


