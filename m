Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460AE47AF3B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhLTPKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239714AbhLTPJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D31EC0698C7;
        Mon, 20 Dec 2021 06:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15D46118D;
        Mon, 20 Dec 2021 14:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A33C36AE8;
        Mon, 20 Dec 2021 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012095;
        bh=MelOGxsUvzgPtXNlFclQLBgW3ihg6esYfZvXOhm5kuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO6vCmFECZDR/LLsC+++zIGW3O3bsPeQWNOSP2LB1/XRa+vXG26R92puudpevzibH
         avevysiLO2dwlpZpaSKsgWzj9xXfxSJ/VU+pud9I/SU4ms/+n6NZqw43/nCs7SAOLW
         oQGYNkUwhhyb46uTYKl5OOtWX3YfOOV7I6PvcpnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/177] drm/i915/display: Fix an unsigned subtraction which can never be negative.
Date:   Mon, 20 Dec 2021 15:33:49 +0100
Message-Id: <20211220143042.765700556@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 53b3495273282aa844c4613d19c3b30558c70c84 ]

smatch warning:
drivers/gpu/drm/i915/display/intel_dmc.c:601 parse_dmc_fw() warn:
unsigned 'fw->size - offset' is never less than zero

Firmware size is size_t and offset is u32. So the subtraction is
unsigned which can never be less than zero.

Fixes: 3d5928a168a9 ("drm/i915/xelpd: Pipe A DMC plugging")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211210044129.12422-1-harshit.m.mogalapalli@oracle.com
(cherry picked from commit 87bb2a410dcfb617b88e4695edf4beb6336dc314)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dmc.c b/drivers/gpu/drm/i915/display/intel_dmc.c
index b3c8e1c450efb..73076737add75 100644
--- a/drivers/gpu/drm/i915/display/intel_dmc.c
+++ b/drivers/gpu/drm/i915/display/intel_dmc.c
@@ -606,7 +606,7 @@ static void parse_dmc_fw(struct drm_i915_private *dev_priv,
 			continue;
 
 		offset = readcount + dmc->dmc_info[id].dmc_offset * 4;
-		if (fw->size - offset < 0) {
+		if (offset > fw->size) {
 			drm_err(&dev_priv->drm, "Reading beyond the fw_size\n");
 			continue;
 		}
-- 
2.33.0



