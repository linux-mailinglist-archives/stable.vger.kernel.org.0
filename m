Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33DE12C700
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfL2Rwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732333AbfL2Rwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D114720718;
        Sun, 29 Dec 2019 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641964;
        bh=DEZkljZFzwxiwPGfqOja9OmDX5YI3wAlVDzUyPwZqIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAqF9e44fEa+kcYDenoGmqm9WH+ZjrwN2xYDV5lIezRNY77NS/QU/6nymc4/nCWoB
         yNi94Blu6/QogTeGJB3VU+wwBPmZBbChJ5PVjYBpuVhOBJF/NoYSroGm1eHEUkuM8X
         a8kgVDLhIgJnt9MfMKlGXiqsPgtNWhKiCQad0DSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Han Nandor <nandor.han@vaisala.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 233/434] nvmem: core: fix nvmem_cell_write inline function
Date:   Sun, 29 Dec 2019 18:24:46 +0100
Message-Id: <20191229172717.352642814@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8f8be5b00060..5c17cb733224 100644
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



