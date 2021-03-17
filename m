Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14C533E441
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhCQA64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231838AbhCQA56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6657464FAE;
        Wed, 17 Mar 2021 00:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942672;
        bh=8LpXTNgfmmT0/ApRuQPyPnu99fhgrRhPP5y4X55vZ0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQdrzVPIXmroPRoCGeWzJkBROWD38uIQSStjxPOR0McqSOhXSltlCEnAP2gjI4QK9
         3LVwKamOadNzQXQ2tNysulH3hwXCl21dVPHeTH+avfKuh45KPlef3aFGcE+Qw62uvS
         XsYvSNKPOMccBQFDskcOMZbqfvvHEE6EDUVcwmTir84zjSpg8rmD6ZE7gbCQmIUkGk
         Wn6jqOCnTk9OXg02RiaRZiuukeivwI6JBngUkbX5B7CXeUrTWV6vNmYYgdnIA1GYUJ
         OJF1Fp7o2PsE8Q0LXDkydaPJcpkgJKWaEl5Ks2+dWokF5kBLlHY/x8sDiY1stHVpoA
         zIABWcd7ckQlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 47/54] nvme-core: check ctrl css before setting up zns
Date:   Tue, 16 Mar 2021 20:56:46 -0400
Message-Id: <20210317005654.724862-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index a684168fa4a3..66247f8776b7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4031,6 +4031,12 @@ static void nvme_validate_or_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
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

