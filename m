Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7480B3B62DA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhF1OuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236161AbhF1OqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:46:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B257761D11;
        Mon, 28 Jun 2021 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890877;
        bh=uwXgR+Z8KY/tXQ+guIsu06wywkj1iLX7ws+vASt2Sdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQj4zWZElJnwZhdpRznshJLWcQouvpc7uCNdNhCz9vUHGW/PbxBPng6FUTnPeY/pV
         GIoMnd6Z3S2zA9IKTTEZiI80JyKYBfp5dai0yEcPCXQpxf5UQVKzzbl/+MMq0OXeCQ
         j34thSVhSlveQiSlX4KbPNyxB7TgSXiryMAtBL+0iF/0uAaiUHEiB09ldp3AopTS1u
         t7gGhvC4a6W/3VN5HIDoe7YiEYrpXRADZkgaowgqgqHp3C/O8bzM7CKix/16DYF7WQ
         7ST6JHXzxBFuCgnbTCDBIadQIwCZwunykfZYvciii53Xxsrxlskywb2SpPBNeEQgTb
         1RqSzndl4sqlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/109] net: qed: Fix memcpy() overflow of qed_dcbx_params()
Date:   Mon, 28 Jun 2021 10:32:59 -0400
Message-Id: <20210628143305.32978-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 5900a506bf8d..ff8a7750d3c0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1294,9 +1294,11 @@ int qed_dcbx_get_config_params(struct qed_hwfn *p_hwfn,
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

