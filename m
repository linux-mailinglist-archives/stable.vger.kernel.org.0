Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB76650047
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiLRQMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiLRQMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:12:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5FFDFEF;
        Sun, 18 Dec 2022 08:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFF360DB4;
        Sun, 18 Dec 2022 16:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03845C433D2;
        Sun, 18 Dec 2022 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379531;
        bh=mvMMLmvxlfsWFgwEr+ZHtBmL6gLBDdJIqM9J7cHhbW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYlbTt/kqkoh7mBMsAaEIegthjA9aAcKjdW4K80e+PQbVhjMKqVGhucOqM/EiEaxv
         6L3gt4/lgg26lKDXMRaEgAZtWMfXZeOvU6U3QKcYW+XLpoWHbzZexE/GxJVYLqXhHB
         ZLoQ4ro9gwKSYDuO+nUi6rPEC+2ynA/DiaRiVKM4nUIOVRn6/puURuTdGi0qfy0IkD
         DQYBM4YmYJSF58fLY4AxqRGPWko8wNdAKDWVqiKsdgkWBiWxsJVoE0UHBF1wPL0Zt3
         B8mU6/dx+cJyjEJgDBKgHUo1VXBnZdPhhSjcdRsr9p5+7wezXlhC4/dIeY9l/H8kaq
         4yo5Lv49uDYSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Lei <yan_lei@dahuatech.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 58/85] media: dvb-frontends: fix leak of memory fw
Date:   Sun, 18 Dec 2022 11:01:15 -0500
Message-Id: <20221218160142.925394-58-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Lei <yan_lei@dahuatech.com>

[ Upstream commit a15fe8d9f1bf460a804bcf18a890bfd2cf0d5caa ]

Link: https://lore.kernel.org/linux-media/20220410061925.4107-1-chinayanlei2002@163.com
Signed-off-by: Yan Lei <yan_lei@dahuatech.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/bcm3510.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index da0ff7b44da4..68b92b4419cf 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -649,6 +649,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 		deb_info("firmware chunk, addr: 0x%04x, len: 0x%04x, total length: 0x%04zx\n",addr,len,fw->size);
 		if ((ret = bcm3510_write_ram(st,addr,&b[i+4],len)) < 0) {
 			err("firmware download failed: %d\n",ret);
+			release_firmware(fw);
 			return ret;
 		}
 		i += 4 + len;
-- 
2.35.1

