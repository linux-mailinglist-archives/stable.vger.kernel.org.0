Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCFD29B820
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799567AbgJ0PcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799561AbgJ0PcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4320920728;
        Tue, 27 Oct 2020 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812729;
        bh=v73Ta+ScJRWCFopas3K9azkdlpQ0DyatyfvApVT089E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jmrgcyi24Ct87iwrPK1d/Gep22yRTbN/i4Qhdw9mIL/b87F4HqsozY1GGfYpcGU1R
         33KzBzirU1wIduxPE9gxDp/LJxubyJaQSBgZ5CJYCsnRLqKkRYbpd5G6IldXK+Rr8n
         ckAZTHwVTTjBUuux8sTou+W5TLqn/Dz2vpCD9KfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadym Kochan <vadym.kochan@plvision.eu>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 280/757] nvmem: core: fix missing of_node_put() in of_nvmem_device_get()
Date:   Tue, 27 Oct 2020 14:48:50 +0100
Message-Id: <20201027135503.718376550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>

[ Upstream commit b1c194dcdb1425fa59eec61ab927cfff33096149 ]

of_parse_phandle() returns device_node with incremented ref count
which needs to be decremented by of_node_put() when device_node
is not used.

Fixes: e2a5402ec7c6 ("nvmem: Add nvmem_device based consumer apis.")
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200917134437.16637-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 6cd3edb2eaf65..204a515d8bc5d 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -835,6 +835,7 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
 {
 
 	struct device_node *nvmem_np;
+	struct nvmem_device *nvmem;
 	int index = 0;
 
 	if (id)
@@ -844,7 +845,9 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
 	if (!nvmem_np)
 		return ERR_PTR(-ENOENT);
 
-	return __nvmem_device_get(nvmem_np, device_match_of_node);
+	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
+	of_node_put(nvmem_np);
+	return nvmem;
 }
 EXPORT_SYMBOL_GPL(of_nvmem_device_get);
 #endif
-- 
2.25.1



