Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE59549A23F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365627AbiAXXvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578620AbiAXWDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:03:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FE3C036BEC;
        Mon, 24 Jan 2022 12:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9953B61548;
        Mon, 24 Jan 2022 20:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719A7C340E5;
        Mon, 24 Jan 2022 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056902;
        bh=+AaJ2Kyc9/AN4fMiQbu1GuSehzeuq+HaoOnzLpJMD20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYx+Xgn5VObElOyZOVszM5x1MikZLEBN2V0kzEWXDMwAcSQWu2OdOh08C3LadcVeh
         zEhyXU4DbIM8+QCjYkCEzdo/cOHoFLMYtY5gOdnYgpRi7jHTMV6bXPkZs3qQdIQCKp
         FqDEftjshnbUOXV+Up7tyJIzFXG9uhqWIX5n7v6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/846] nvmem: core: set size for sysfs bin file
Date:   Mon, 24 Jan 2022 19:42:34 +0100
Message-Id: <20220124184122.998895115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



