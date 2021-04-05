Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EED0354442
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbhDEQEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242082AbhDEQEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F8E613D6;
        Mon,  5 Apr 2021 16:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638673;
        bh=bqcHL98/5DIfVZ4OpfrnQ/Lr5T/8yN1YD9VjwhQTA2g=;
        h=From:To:Cc:Subject:Date:From;
        b=CO6QIQ4Cleujgm/LHeoGEbFcKkI82Bc7lt0lAEQ7qtjzas2IawbCyD4PaPxbPtKD0
         JntFBb8bOnnhi6pIocK5TgfWuuL3rSw2dbGioFQTDk5USRaZgfudNkw1/kYMPB0EC2
         RoLKn7YFw7K78ZzX+WLGLiMvH0/XaJW6YjiGVn5To9HZsoK1ZdR5jogaUCQl00C8iQ
         wpRsVKEPyz/NSGYsvwxlCgthFLWJvDBmukXKIgLWg8nOXWnh1JiYmqijk4V/GnjQAd
         kKQUuapGkHIkWHG4B/+9w9jzlIS6Z+Q0lbNCe1YA5xTZulwpYheJHRHK0Zprq5lrLp
         eDrXIbTKkNPgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/22] interconnect: core: fix error return code of icc_link_destroy()
Date:   Mon,  5 Apr 2021 12:04:10 -0400
Message-Id: <20210405160432.268374-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 715ea61532e731c62392221238906704e63d75b6 ]

When krealloc() fails and new is NULL, no error return code of
icc_link_destroy() is assigned.
To fix this bug, ret is assigned with -ENOMEM hen new is NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20210306132857.17020-1-baijiaju1990@gmail.com
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 5ad519c9f239..8a1e70e00876 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -942,6 +942,8 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst)
 		       GFP_KERNEL);
 	if (new)
 		src->links = new;
+	else
+		ret = -ENOMEM;
 
 out:
 	mutex_unlock(&icc_lock);
-- 
2.30.2

