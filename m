Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D62328C42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbhCASr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhCASmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B4E464EEF;
        Mon,  1 Mar 2021 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618859;
        bh=EBdAzRJz9PfdVEyuUD3fGqOhvYtPgREERfBHLEbTrzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCTN/hEM9YKLMRosKNKXpAOJ7DRekcxlqcg+EX7/vt8huihhsqu1Do1MCZDfWrkt5
         3GMkY8IBzJQD62Rb9vm21uXaWOHbqv5r8N+5AyDARHNQ0mWw17ZzH8y/wBd7gxWptn
         C8Hp1C/qCiX/DZromxMfFRPZ6fi1CoTRYGBLSbt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/663] nvmet: set status to 0 in case for invalid nsid
Date:   Mon,  1 Mar 2021 17:08:12 +0100
Message-Id: <20210301161153.889855557@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit 40244ad36bcfb796a6bb9e95bdcbf8ddf3134509 ]

For unallocated namespace in nvmet_execute_identify_ns() don't set the
status to NVME_SC_INVALID_NS, set it to zero.

Fixes: bffcd507780e ("nvmet: set right status on error in id-ns handler")
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 80ac91e67a1f1..e20dea5c44f7b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -487,7 +487,7 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 	/* return an all zeroed buffer if we can't find an active namespace */
 	req->ns = nvmet_find_namespace(ctrl, req->cmd->identify.nsid);
 	if (!req->ns) {
-		status = NVME_SC_INVALID_NS;
+		status = 0;
 		goto done;
 	}
 
-- 
2.27.0



