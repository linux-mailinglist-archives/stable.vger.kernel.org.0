Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC9733E3A4
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhCQA5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F0664FB2;
        Wed, 17 Mar 2021 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942602;
        bh=6yxJo0m1SHli94yQhjg+gVBOREYv0JUFfyEY2W+/Ru4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CClVIC/FsGE2+K7sLqXEmIhUGmc5geru/40g5aeUVkSwbxTWxxsxrAQWyCZIZdPra
         8ZyNNj8+RyKvqNq84yxxXr60ZFa6pK0PwiGK24uKlA8MU3HONUZ1MebOacbojVGrrp
         YPjf1igGw5B0MwW+pSYPSo1oJV9l6Zimaq3tMVL7ePBX8eWBGrRmhnynaAShOHnPx/
         +JbBD3C708caqkJnj7qJ/HdJbr8AFFjLscOLfIeCyAfTj9yQtkcTopAaWOOaVju6gq
         ry9wV0jCVLdn+uOmVuCocWhWczrbTVY/XZprud2MA57Ve3T71ODzXFZp3XIfheJX7o
         kx9Hc00gr0DIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 53/61] nvme-core: check ctrl css before setting up zns
Date:   Tue, 16 Mar 2021 20:55:27 -0400
Message-Id: <20210317005536.724046-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 0ec84df4953bd42c6583a555773f1d4996a061eb ]

Ensure multiple Command Sets are supported before starting to setup a
ZNS namespace.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[hch: move the check around a bit]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 28bfe5bbf769..e5cc92a6a16d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4081,6 +4081,12 @@ static void nvme_validate_or_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 				nsid);
 			break;
 		}
+		if (!nvme_multi_css(ctrl)) {
+			dev_warn(ctrl->device,
+				"command set not reported for nsid: %d\n",
+				ns->head->ns_id);
+			break;
+		}
 		nvme_alloc_ns(ctrl, nsid, &ids);
 		break;
 	default:
-- 
2.30.1

