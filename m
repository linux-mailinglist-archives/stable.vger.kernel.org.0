Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A051F2321
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFHXMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbgFHXMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EC4D208C7;
        Mon,  8 Jun 2020 23:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657974;
        bh=erJVN+buUEYGqmBw7CVqdYyn2GDrJqQBxNNiVescaz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03zL/u3mfrjudm9vI8T9qIa8RA2TsVpLdhXxWh/nnCpwU8K1DAUFqbBq+lEXXclls
         XdCRB+q6mVHj1Nml3gM1pypubPZX+HLZ706g0G78gR7nxLJcNo0DKisY7kY7V20ZLt
         9+HzWoQaXRUho5MIEaeqKHmMEDoeMt7GwYvrY/7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom St Denis <tom.stdenis@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 036/606] drm/amd/amdgpu: add raven1 part to the gfxoff quirk list
Date:   Mon,  8 Jun 2020 19:02:41 -0400
Message-Id: <20200608231211.3363633-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom St Denis <tom.stdenis@amd.com>

commit 975f543e7522e17b8a4bf34d7daeac44819aee5a upstream.

On my raven1 system (rev c6) with VBIOS 113-RAVEN-114 GFXOFF is
not stable (resulting in large block tiling noise in some applications).

Disabling GFXOFF via the quirk list fixes the problems for me.

Signed-off-by: Tom St Denis <tom.stdenis@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 73337e658aff..906648fca9ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1177,6 +1177,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc8 },
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=207171 */
 	{ 0x1002, 0x15dd, 0x103c, 0x83e7, 0xd3 },
+	/* GFXOFF is unstable on C6 parts with a VBIOS 113-RAVEN-114 */
+	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.25.1

