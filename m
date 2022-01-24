Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A2E49A99A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbiAYDY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444565AbiAXVBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067FEC04D63F;
        Mon, 24 Jan 2022 12:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8387361307;
        Mon, 24 Jan 2022 20:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAA2C340E5;
        Mon, 24 Jan 2022 20:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054544;
        bh=Y5jlLYsWFAHRggd1xo9Vqx2B9cfFo1Wl0XfIsTSkE0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4viPQVN6EhG+4xeuxl+CLLNKiV5qPI+gC5qU6kxGRLv2JuiOJlrXHeGAK0RikqoG
         751M43a3SUS/2QjBgjQ9Pjp1S0QhjgPlO85VK1GNQLJctjDONnREQAWEc19T489M9H
         xPlvZOT9KiKrTd+pvuCAPTDLaUk0SxXF2KKW1PHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/563] nvmem: core: set size for sysfs bin file
Date:   Mon, 24 Jan 2022 19:43:07 +0100
Message-Id: <20220124184039.054739776@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



