Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60261737E3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387900AbfGXTX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387898AbfGXTX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:23:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B18218F0;
        Wed, 24 Jul 2019 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996236;
        bh=w7VUb5FPr2CBplIfXrUWD0r0lOuMXnxsaKY/LNDz9mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ7DqTIApveocwsscvpb1QvtoB5vpos5G32gBJkKDm4VV7OW9nApzYViN8xEi/b1k
         gMjTQqlTFjv+KixO7XS1avBhifZ94khwZYO5fY5btr/qwPtuzlU4ji2DAkDH6kVuWt
         CvLI0WLdP+96SzIITGYoRoI+ETytPCkDPlUbHO2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 027/413] media: venus: firmware: fix leaked of_node references
Date:   Wed, 24 Jul 2019 21:15:18 +0200
Message-Id: <20190724191737.420017002@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2c41cc0be07b5ee2f1167f41cd8a86fc5b53d82c ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
drivers/media/platform/qcom/venus/firmware.c:90:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.
drivers/media/platform/qcom/venus/firmware.c:94:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.
drivers/media/platform/qcom/venus/firmware.c:128:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 82, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/firmware.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 1eba23409ff3..d3d1748a7ef6 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -78,11 +78,11 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 
 	ret = of_address_to_resource(node, 0, &r);
 	if (ret)
-		return ret;
+		goto err_put_node;
 
 	ret = request_firmware(&mdt, fwname, dev);
 	if (ret < 0)
-		return ret;
+		goto err_put_node;
 
 	fw_size = qcom_mdt_get_size(mdt);
 	if (fw_size < 0) {
@@ -116,6 +116,8 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	memunmap(mem_va);
 err_release_fw:
 	release_firmware(mdt);
+err_put_node:
+	of_node_put(node);
 	return ret;
 }
 
-- 
2.20.1



