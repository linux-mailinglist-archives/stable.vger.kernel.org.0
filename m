Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FD621FB7B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgGNTBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731124AbgGNS7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E8122507;
        Tue, 14 Jul 2020 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753162;
        bh=Cu3BvAfYn5LTqrRnIppM+ink8n0nkxKYVSqNHITujiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXnB/ocpExMJAa/IsdVmp1ImuXAkFAMndTreZcDBIVzsJiMqHtHZmVkGwaifmKoG1
         mIHwd8aswo5rmjWu80HgGAsx6JxgnZ8Yec4eNr5uAFO6RckNUCbsdHGDJYwmRda/B8
         0Ly/KJ6NoKLKCN+iyXvXfIT4IIQUpxi27E4EmL4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 143/166] drm/amdgpu: asd function needs to be unloaded in suspend phase
Date:   Tue, 14 Jul 2020 20:45:08 +0200
Message-Id: <20200714184122.672952668@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

commit 20303ec5d2165ee6344190274bc59118921f71d9 upstream.

Unload ASD function in suspend phase.

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1685,6 +1685,12 @@ static int psp_suspend(void *handle)
 		return ret;
 	}
 
+	ret = psp_asd_unload(psp);
+	if (ret) {
+		DRM_ERROR("Failed to unload asd\n");
+		return ret;
+	}
+
 	ret = psp_ring_stop(psp, PSP_RING_TYPE__KM);
 	if (ret) {
 		DRM_ERROR("PSP ring stop failed\n");


