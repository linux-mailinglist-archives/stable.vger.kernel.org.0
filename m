Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96A13B601D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhF1OWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233222AbhF1OVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE6A61C8E;
        Mon, 28 Jun 2021 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889954;
        bh=yGIMFfXBv351FkDVH59jFGEwcYsPTos591RKcHoH8NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ1fDWwFvX90VHnEAYcXVahPiRwZ9oChmKoalPmSzgOlCzjYMtJ8dXx6tvArAa68N
         mKAzeDJ8X52lCcoXFX8T1Ygw46My+BZjukllMwx+Up/t8WUuqRzOW0zMUkBkBPAcWK
         q19U0Vboaf8edlCVUW2dwG7h1mNAzQdx4F4DXE62VSL+gkHFzYgh3o68E6JTiL5cn9
         Vyxd0J7gfbcZyRN5BiNeKgx3XetUyr3x9KrhO1G4V1Qs/00nKPGUcUtH07uBvVjlMj
         +SWIpom8lyM/TqAK5BcyptPGGpdWpdmE1pyYywErfOmZuAQ/7+e0YfyX2RzecSomGf
         28HJ9rNfTdqXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 053/110] net: qed: Fix memcpy() overflow of qed_dcbx_params()
Date:   Mon, 28 Jun 2021 10:17:31 -0400
Message-Id: <20210628141828.31757-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1c200f832e14420fa770193f9871f4ce2df00d07 ]

The source (&dcbx_info->operational.params) and dest
(&p_hwfn->p_dcbx_info->set.config.params) are both struct qed_dcbx_params
(560 bytes), not struct qed_dcbx_admin_params (564 bytes), which is used
as the memcpy() size.

However it seems that struct qed_dcbx_operational_params
(dcbx_info->operational)'s layout matches struct qed_dcbx_admin_params
(p_hwfn->p_dcbx_info->set.config)'s 4 byte difference (3 padding, 1 byte
for "valid").

On the assumption that the size is wrong (rather than the source structure
type), adjust the memcpy() size argument to be 4 bytes smaller and add
a BUILD_BUG_ON() to validate any changes to the structure sizes.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index 17d5b649eb36..e81dd34a3cac 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1266,9 +1266,11 @@ int qed_dcbx_get_config_params(struct qed_hwfn *p_hwfn,
 		p_hwfn->p_dcbx_info->set.ver_num |= DCBX_CONFIG_VERSION_STATIC;
 
 	p_hwfn->p_dcbx_info->set.enabled = dcbx_info->operational.enabled;
+	BUILD_BUG_ON(sizeof(dcbx_info->operational.params) !=
+		     sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	memcpy(&p_hwfn->p_dcbx_info->set.config.params,
 	       &dcbx_info->operational.params,
-	       sizeof(struct qed_dcbx_admin_params));
+	       sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	p_hwfn->p_dcbx_info->set.config.valid = true;
 
 	memcpy(params, &p_hwfn->p_dcbx_info->set, sizeof(struct qed_dcbx_set));
-- 
2.30.2

