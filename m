Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB001195F3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLJVX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:23:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728658AbfLJVLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F00B2246A4;
        Tue, 10 Dec 2019 21:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012261;
        bh=PuHL7faz8DEVq0QsM4cBqyQnkrewJSkeXBTOVopSeb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFEB1xy91jCSKqTN3zyPbZBWNrk1dA9OHa4gZ4jEPJBAE9LXbOj+aqxTVZY5CF0JC
         EsGwsYMmHLOSSFHOx5q190KjS9wxez3O9ROkTtkkPPmuHpDkpgqqzLtVMMPpO+ynpP
         6S+S/Kg6aRplOZ5f4P7c6q75Jy250wHbxmQyto6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        kbuild test robot <lkp@intel.com>,
        Han Nandor <nandor.han@vaisala.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 207/350] nvmem: core: fix nvmem_cell_write inline function
Date:   Tue, 10 Dec 2019 16:05:12 -0500
Message-Id: <20191210210735.9077-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 9b8303fc6efa724bd6a90656434fbde2cc6ceb2c ]

nvmem_cell_write's buf argument uses different types based on
the configuration of CONFIG_NVMEM. The function prototype for
enabled NVMEM uses 'void *' type, but the static dummy function
for disabled NVMEM uses 'const char *' instead. Fix the different
behaviour by always expecting a 'void *' typed buf argument.

Fixes: 7a78a7f7695b ("power: reset: nvmem-reboot-mode: use NVMEM as reboot mode write interface")
Reported-by: kbuild test robot <lkp@intel.com>
Cc: Han Nandor <nandor.han@vaisala.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-By: Han Nandor <nandor.han@vaisala.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20191029114240.14905-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvmem-consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 8f8be5b000602..5c17cb7332241 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -118,7 +118,7 @@ static inline void *nvmem_cell_read(struct nvmem_cell *cell, size_t *len)
 }
 
 static inline int nvmem_cell_write(struct nvmem_cell *cell,
-				    const char *buf, size_t len)
+				   void *buf, size_t len)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.20.1

