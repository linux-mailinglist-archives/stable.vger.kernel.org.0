Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC713F69A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbgAPRBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388175AbgAPRBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE2D24679;
        Thu, 16 Jan 2020 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194105;
        bh=rbXhNOxvUazaqZblzdZbObXJnK/bJaRavdGDm0WRNxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3QGIB0wSiETyjTOok4TTqinLCQ5lAEeiREPvSi4o5NxkQOpV4kapFC5PxhhKPvUZ
         vf3F7PdI/PVdDe6vcQDS4RL2uPtKcGOrLfcYetXP94tpH9V+a9vslQBmclgOeKvBm1
         8t4FNM5NlG3Zn3kAhkk5vGZtW28ZqHernD66VhzE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 204/671] drm/nouveau: fix missing break in switch statement
Date:   Thu, 16 Jan 2020 11:51:53 -0500
Message-Id: <20200116165940.10720-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 785cf1eeafa23ec63f426d322401054d13abe2a3 ]

The NOUVEAU_GETPARAM_PCI_DEVICE case is missing a break statement and falls
through to the following NOUVEAU_GETPARAM_BUS_TYPE case and may end up
re-assigning the getparam->value to an undesired value. Fix this by adding
in the missing break.

Detected by CoverityScan, CID#1460507 ("Missing break in switch")

Fixes: 359088d5b8ec ("drm/nouveau: remove trivial cases of nvxx_device() usage")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_abi16.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index e67a471331b5..6ec745873bc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -214,6 +214,7 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 			WARN_ON(1);
 			break;
 		}
+		break;
 	case NOUVEAU_GETPARAM_FB_SIZE:
 		getparam->value = drm->gem.vram_available;
 		break;
-- 
2.20.1

