Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E557490E51
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243093AbiAQRIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242467AbiAQRGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:06:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98935C0612F3;
        Mon, 17 Jan 2022 09:04:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C0056119F;
        Mon, 17 Jan 2022 17:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBC3C36B07;
        Mon, 17 Jan 2022 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439042;
        bh=Y5jlLYsWFAHRggd1xo9Vqx2B9cfFo1Wl0XfIsTSkE0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjaBdLrQV+lNPtlIQRvn6AxNaz4c5Y7CsDmPmvsWWoKpNiLVnQBd4tN4FJVyKDx2j
         u4k1pWkAZX3AV8lOTVcYNKt1jA7OKSaPGXBhEMErcPKffbw3NFyYdzvF5Hm42uuPFH
         PlORhlL5ne3rQcePWUE7FkpmsQqvV27BNedtoZyGJyBeTbGZTjH7Cv1NQ3IZ1E24t6
         lOmgD9aXC+SEKIOsfEBsie5Ntuccs+d46Q+G/eY9xHw7cI66Oo3Az3h7Q0iqR9sGSM
         1R1H0ln0Ybjz8t21ZUDnM/+2tA0CUVXMVvlhqE8W2aMMsWbMflKm77od0FEWBbOl5l
         nRNa4VkCfrDQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Gilles BULOZ <gilles.buloz@kontron.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 16/34] nvmem: core: set size for sysfs bin file
Date:   Mon, 17 Jan 2022 12:03:06 -0500
Message-Id: <20220117170326.1471712-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 86192251033308bb42f1e9813c962989d8ed07ec ]

For some reason we never set the size for nvmem sysfs binary file.
Set this.

Reported-by: Gilles BULOZ <gilles.buloz@kontron.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211130133909.6154-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 6b170083cd248..21d89d80d0838 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -222,6 +222,8 @@ static umode_t nvmem_bin_attr_is_visible(struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
 
+	attr->size = nvmem->size;
+
 	return nvmem_bin_attr_get_umode(nvmem);
 }
 
-- 
2.34.1

