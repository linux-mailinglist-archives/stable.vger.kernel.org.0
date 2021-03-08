Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94398330E62
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCHMgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhCHMgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A35C0651DD;
        Mon,  8 Mar 2021 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206984;
        bh=hTBnQBCLVMxR4QhT3h5lrSDArmxK5D2kuTiGwbZvCTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEeIWDQgwPeUydhH7ZkjB6uMhJ/T/24Zw2mzOhayNsS0hJAITTGBvOGKKqLUDRL8V
         U2tPLQVyL/cKzfSbxPFkucG8hzYKsoxt4fnAht6z3NtC1o+jZjMyJwB0+fg3bELH/V
         D/v6V+lwZLn+29BQQIUZnxjxNlJ6jFODL72KIN/Y=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 27/44] drm/amdgpu: Only check for S0ix if AMD_PMC is configured
Date:   Mon,  8 Mar 2021 13:35:05 +0100
Message-Id: <20210308122719.904210982@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alex Deucher <alexander.deucher@amd.com>

commit 31ada99bdd1b4d6b80462eeb87d383f374409e2a upstream.

The S0ix check only makes sense if the AMD PMC driver is
present.  We need to use the legacy S3 pathes when the
PMC driver is not present.

Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -903,10 +903,11 @@ void amdgpu_acpi_fini(struct amdgpu_devi
  */
 bool amdgpu_acpi_is_s0ix_supported(struct amdgpu_device *adev)
 {
+#if defined(CONFIG_AMD_PMC)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return true;
 	}
-
+#endif
 	return false;
 }


