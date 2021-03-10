Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEF5333E3D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhCJNZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233214AbhCJNZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFAC164FFC;
        Wed, 10 Mar 2021 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382706;
        bh=S/7YqJowUu7mr8v7DdJSfZ8c/UGkSNjW14yt8/iWBCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6aVz/LvrGmfZEMZWInSN3WaKTZeqwoCQPLzz9YecF13h7/p1dLNTDdQFIDObXPiU
         QgQmNUmElFypxOTK5yDT+6aamN5l5L/U/l5rK1bhzFfbrVgtKwlwgPRnYSYR4fpDuY
         unYJRA2O2x0z/b4sHjjlR/A7FKIohUyCY96/IYD4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 08/39] drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie
Date:   Wed, 10 Mar 2021 14:24:16 +0100
Message-Id: <20210310132319.995385177@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kevin Wang <kevin1.wang@amd.com>

commit 1aa46901ee51c1c5779b3b239ea0374a50c6d9ff upstream.

the register offset isn't needed division by 4 to pass RREG32_PCIE()

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -239,7 +239,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	while (size) {
 		uint32_t value;
 
-		value = RREG32_PCIE(*pos >> 2);
+		value = RREG32_PCIE(*pos);
 		r = put_user(value, (uint32_t *)buf);
 		if (r)
 			return r;
@@ -282,7 +282,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 		if (r)
 			return r;
 
-		WREG32_PCIE(*pos >> 2, value);
+		WREG32_PCIE(*pos, value);
 
 		result += 4;
 		buf += 4;


