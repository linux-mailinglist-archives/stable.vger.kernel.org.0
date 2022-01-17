Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9200F490D86
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiAQRDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbiAQRCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2FCAB81142;
        Mon, 17 Jan 2022 17:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E890EC36AE3;
        Mon, 17 Jan 2022 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438924;
        bh=+AaJ2Kyc9/AN4fMiQbu1GuSehzeuq+HaoOnzLpJMD20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4RqkopBfP6BM6GdHjrRs43894MOeQ3KpeyStLOpClcnfoeN60Ke7pQF3VY1jEDs/
         JaVunxeEF0OA9e/knYaCkYAj62i0ZRIWD0TnBnrbvd5yACq4mJTa7Qfo8RJkrIGXmC
         B0yJCuwn1yOLa+GKbRrTreP4Iiob13nXBtH4Fn5h3ksiv1jwhVtoRFw2AwQewyBJD+
         IlRXp9qKHHgXTZxrB5EziWuqyWtjTlE7Oj706ydHYrb2IvP6kOpPEzVgcnvRwZ36+5
         U2pjXUFXta0w1HnRzake67GLFz9oKeRto+gsU55W9Q/h2XF4DTmqkAZcja/AYNfie9
         hMlsgDFPBAjZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Gilles BULOZ <gilles.buloz@kontron.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 16/44] nvmem: core: set size for sysfs bin file
Date:   Mon, 17 Jan 2022 12:00:59 -0500
Message-Id: <20220117170127.1471115-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 8976da38b375a..9aecb83021a2d 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -307,6 +307,8 @@ static umode_t nvmem_bin_attr_is_visible(struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct nvmem_device *nvmem = to_nvmem_device(dev);
 
+	attr->size = nvmem->size;
+
 	return nvmem_bin_attr_get_umode(nvmem);
 }
 
-- 
2.34.1

