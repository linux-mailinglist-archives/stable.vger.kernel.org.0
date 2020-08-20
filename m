Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56DB24B287
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgHTJcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbgHTJbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B664822B4E;
        Thu, 20 Aug 2020 09:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915904;
        bh=E9us+8P+2swPNnKOpTkvu4a59RwLHeKEXwH8xJTtIMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcuOoSX+A/ihrwHO8L9jpMKZbcOFYlggaer586//rAi+h2iutHFR6X6ioOIDf09Ot
         8i4hEg+aWLLKB/533Jov3WKsz+2IRq9U/ayEy3uxSNrZ1HLV4AJOoZSwgEKpWnjax7
         HK67Ib3N8ql3Ql1X3jho6utmeOjVPnC1IH1EQdCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 175/232] ubi: fastmap: Free fastmap next anchor peb during detach
Date:   Thu, 20 Aug 2020 11:20:26 +0200
Message-Id: <20200820091621.294484832@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c3fc1a3919e35a9d8157ed3ae6fd0a478293ba2c ]

ubi_wl_entry related with the fm_next_anchor PEB is not freed during
detach, which causes a memory leak.
Don't forget to release fm_next_anchor PEB while detaching ubi from
mtd when CONFIG_MTD_UBI_FASTMAP is enabled.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Fixes: 4b68bf9a69d22d ("ubi: Select fastmap anchor PEBs considering...")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 83afc00e365a5..28f55f9cf7153 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -381,6 +381,11 @@ static void ubi_fastmap_close(struct ubi_device *ubi)
 		ubi->fm_anchor = NULL;
 	}
 
+	if (ubi->fm_next_anchor) {
+		return_unused_peb(ubi, ubi->fm_next_anchor);
+		ubi->fm_next_anchor = NULL;
+	}
+
 	if (ubi->fm) {
 		for (i = 0; i < ubi->fm->used_blocks; i++)
 			kfree(ubi->fm->e[i]);
-- 
2.25.1



