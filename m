Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFB3A620E
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbhFNKz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234525AbhFNKw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:52:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D34A6147E;
        Mon, 14 Jun 2021 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667185;
        bh=Qsd7/ZcxgyX7sGOwkV0r3LGLN/TenipAy3EBGId8fNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+YMZ3GLErPTtpqa8hYdKBH7EHGztbM4JTnA3tTxyM49i+bBKmEBsfxFEZ1QOjfDR
         sS6XPveiuQAzKy6pIUQQCiLHB6scIebzqxSG4QBT3VPxNsgAdJGmM+uz1WUzLfRlPz
         n1Hx2tZKmZ/uDDF5jxG5osRWXV9yyCm4K8J0LVMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/84] nvme-fabrics: decode host pathing error for connect
Date:   Mon, 14 Jun 2021 12:27:04 +0200
Message-Id: <20210614102647.243331557@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 4d9442bf263ac45d495bb7ecf75009e59c0622b2 ]

Add an additional decoding for 'host pathing error' during connect.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 3bb71f177dfd..d884187d7706 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -336,6 +336,11 @@ static void nvmf_log_connect_error(struct nvme_ctrl *ctrl,
 			cmd->connect.recfmt);
 		break;
 
+	case NVME_SC_HOST_PATH_ERROR:
+		dev_err(ctrl->device,
+			"Connect command failed: host path error\n");
+		break;
+
 	default:
 		dev_err(ctrl->device,
 			"Connect command failed, error wo/DNR bit: %d\n",
-- 
2.30.2



