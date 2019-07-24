Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895DF73A18
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbfGXTqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391136AbfGXTqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 847AC22AEC;
        Wed, 24 Jul 2019 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997607;
        bh=3hy9gzkHKUTO3An2RXMx7190IZqmTuxNC+BLw3pswNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaxIyqqPcIQI81EjYJQtsZdZJuHnt8RYWd93mR7q+VSvlUCbTdivVhfIvvDbdg6hn
         qDcKQreiKna45HqBiWwOT/9m4B7DYirXnM+bQQRr44s4OSKWkP1pC4u3S4MoDND43q
         xaFU4EMM42VLRZE605ehE1WP5QJ+1DqeaLZcoyMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 030/371] media: venus: firmware: fix leaked of_node references
Date:   Wed, 24 Jul 2019 21:16:22 +0200
Message-Id: <20190724191726.763980984@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
index 6cfa8021721e..f81449b400c4 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -87,11 +87,11 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 
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
@@ -125,6 +125,8 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	memunmap(mem_va);
 err_release_fw:
 	release_firmware(mdt);
+err_put_node:
+	of_node_put(node);
 	return ret;
 }
 
-- 
2.20.1



