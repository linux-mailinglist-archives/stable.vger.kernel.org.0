Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79AC499994
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351526AbiAXVgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51250 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453615AbiAXVad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:30:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1337361028;
        Mon, 24 Jan 2022 21:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE51C340E4;
        Mon, 24 Jan 2022 21:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059830;
        bh=Zy5v5fLQBLXnARGxYzyL5FpJcmsXb0/iPQFT4iszAW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wi5gInQVql5hu8dVh8s4mWxKPbz26p+IkeKKnU4Tcx/onmCfaEymZjWzhCb+6rRbt
         WSzz74wtWmV5/RmVHXDkMTFmzHVshVG7obztzKR3Xv/rZxiQC0x6N5s3GEjga3STEv
         9LTmCQa8pLmstfENj2XWOqBHEhSa2A6KWXQGbJhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0748/1039] nvmem: core: set size for sysfs bin file
Date:   Mon, 24 Jan 2022 19:42:17 +0100
Message-Id: <20220124184150.476108873@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



