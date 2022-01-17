Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC12490CE2
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241437AbiAQQ7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241371AbiAQQ7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEBBC061748;
        Mon, 17 Jan 2022 08:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1412611C3;
        Mon, 17 Jan 2022 16:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54FEC36AE7;
        Mon, 17 Jan 2022 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438774;
        bh=Zy5v5fLQBLXnARGxYzyL5FpJcmsXb0/iPQFT4iszAW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzsQzesbykZs6hLNPg5xvfzszRq9qMDNkhrFlFtKLZteMUGakJNkH393ZZsgKI6Y2
         33OH7T2PtEpSKg1oFPwBjwEoLKrWZ0DNWZ9BJFdd+g4WW+gqMmUJeA6Vj+rGq5aoJz
         FzZ5BM2ww0FttJazc5cBzQKB6ttiMhJVnniH6gHrkLdF708ewTjeIy3PWq7Guq1Mnh
         McM3zd4iIXfmK+DIIfYkkVUtHwqFEZ/MdMIWlc3mLhJZV96dOQUN9i5YcUM7sHB4K1
         PXTkD0Vbz9pcjD3bexYeoh3BBleJzYZlvyZ7NaoMjb8CURrnIFQmV36s0+adAZHhd4
         WBdVtku9jgyoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Gilles BULOZ <gilles.buloz@kontron.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.16 17/52] nvmem: core: set size for sysfs bin file
Date:   Mon, 17 Jan 2022 11:58:18 -0500
Message-Id: <20220117165853.1470420-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
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
index e765d3d0542e5..23a38dcf0fc4d 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -312,6 +312,8 @@ static umode_t nvmem_bin_attr_is_visible(struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
 
+	attr->size = nvmem->size;
+
 	return nvmem_bin_attr_get_umode(nvmem);
 }
 
-- 
2.34.1

