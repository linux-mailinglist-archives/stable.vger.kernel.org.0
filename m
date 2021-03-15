Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2B333B7BD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhCOOBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB4AA64F3F;
        Mon, 15 Mar 2021 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816759;
        bh=5bpKe+F0fIdOCn/JmnKIYlziQBIDZdMJ1Hqho33wp70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avwUZaE8laE8ZL0DUOwXL09JDj/3bZnXx0mLa4k0YvjM8m4AEBwfJfiLT95pOt70Q
         Vckn48Y4cq5qRHnoH9YTqieMGEThUKRnZoUssdRuiFXI7n7IFijj5TC39HQ1mdsOlx
         Hf6NkSPVnNnnGfvxScmKstcgE/XUnO0ukQPwHlEg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 108/306] drm/amdgpu: fix S0ix handling when the CONFIG_AMD_PMC=m
Date:   Mon, 15 Mar 2021 14:52:51 +0100
Message-Id: <20210315135511.303313998@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Alex Deucher <alexander.deucher@amd.com>

commit a5cb3c1a36376c25cd25fd3e99918dc48ac420bb upstream.

Need to check the module variant as well.

Acked-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -903,7 +903,7 @@ void amdgpu_acpi_fini(struct amdgpu_devi
  */
 bool amdgpu_acpi_is_s0ix_supported(struct amdgpu_device *adev)
 {
-#if defined(CONFIG_AMD_PMC)
+#if defined(CONFIG_AMD_PMC) || defined(CONFIG_AMD_PMC_MODULE)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return true;


