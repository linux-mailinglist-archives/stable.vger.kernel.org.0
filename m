Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC13217190
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgGGPWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgGGPV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62CEC2065D;
        Tue,  7 Jul 2020 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135317;
        bh=PP4vPcVc6oKV+IVd3pArqrJqOU60eDtrGsLUGpLvx6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppWo/wF8sJcyAuHz3Q7QgSWP4HYWnuc/7sl/mthi8FxpCicUXuu9nJgSfIH/7REyM
         Wy281Crw4mKcbKWSboRD7WJiiaP2CU0PLO0gUEoooYuExSyUFtSxfnmuv39BSwuQ39
         8vVWvy8P3iBcjsltpKbagdcvy3NNH5+PJQcco8tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 58/65] drm/amdgpu/atomfirmware: fix vram_info fetching for renoir
Date:   Tue,  7 Jul 2020 17:17:37 +0200
Message-Id: <20200707145755.269878178@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit d7a6634a4cfba073ff6a526cb4265d6e58ece234 upstream.

Renoir uses integrated_system_info table v12.  The table
has the same layout as v11 with respect to this data.  Just
reuse the existing code for v12 for stable.

Fixes incorrectly reported vram info in the driver output.

Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -150,6 +150,7 @@ int amdgpu_atomfirmware_get_vram_width(s
 				(mode_info->atom_context->bios + data_offset);
 			switch (crev) {
 			case 11:
+			case 12:
 				mem_channel_number = igp_info->v11.umachannelnumber;
 				/* channel width is 64 */
 				return mem_channel_number * 64;


