Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B99F47DE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391449AbfKHLqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391445AbfKHLqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D163D2245A;
        Fri,  8 Nov 2019 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213609;
        bh=v1prjkhELBhwKJpCCsadHkv68GhTa67gCjrparn07S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLu3RjxR0l7uVAG7HO6imnDe3EdpaUGP2ljlXR4eLNi9fllKHjR55bNQkUJVgyzOq
         JUoqDQ70bcPmYQlUCsJKz1FBtX3noD27OF4K99xQL5yoKUnZsEytcOlBhhAf6PWilB
         HM/6GyNfx5Oeu53v/ShChiSXTtZ7GWBYyidXqrZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 46/64] nvmem: core: return error code instead of NULL from nvmem_device_get
Date:   Fri,  8 Nov 2019 06:45:27 -0500
Message-Id: <20191108114545.15351-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit ca6ac25cecf0e740d7cc8e03e0ebbf8acbeca3df ]

nvmem_device_get() should return ERR_PTR() on error or valid pointer
on success, but one of the code path seems to return NULL, so fix it.

Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 9ca24e4d5d49c..2a0c5f3b0e509 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -609,7 +609,7 @@ static struct nvmem_device *nvmem_find(const char *name)
 	d = bus_find_device(&nvmem_bus_type, NULL, (void *)name, nvmem_match);
 
 	if (!d)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
 	return to_nvmem_device(d);
 }
-- 
2.20.1

