Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D133650404
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiLRRNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiLRRKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:10:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2151EC41;
        Sun, 18 Dec 2022 08:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B97DCE0C56;
        Sun, 18 Dec 2022 16:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37975C433D2;
        Sun, 18 Dec 2022 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380627;
        bh=e+mK2I0XLSH5ibwB3tkTIJFc3uG7mhmJaeMBe1RVO2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwQwOGcHkdPU6X5kWO+gxZmm1oiMJ1srGrnmODConbt1aQ1KrCx4cFBwk0GmBQcCo
         S0edpwhMwxgXxPFg5BdqQJMDC63AEAp+VmgK/xNDn7NhvWybwbN6Ma8qmcngA+PbDR
         D2CZ7Qw6ey5CK9uY7+ko0NkHM7DV2SjAMTAcCDDPbS+JpeuUtjiOtMF0+c9IVt/cJ5
         iysL2qH5CJDGKNRrjIzU/pbjRPK2KBG8kIuRuWp/SF5+0bRLZahpbRv+Cw2KFlhiod
         nLl56lRTgua/CKtFhJy8z6zBHkxjOLhMLfREnDV8kAZIxpYj7KURLU2eU9Dip8OXmR
         KLkk5hUDnbLaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Lei <yan_lei@dahuatech.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/20] media: dvb-frontends: fix leak of memory fw
Date:   Sun, 18 Dec 2022 11:23:00 -0500
Message-Id: <20221218162305.935724-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162305.935724-1-sashal@kernel.org>
References: <20221218162305.935724-1-sashal@kernel.org>
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
index bb698839e477..fc1dbdfb0cba 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -648,6 +648,7 @@ static int bcm3510_download_firmware(struct dvb_frontend* fe)
 		deb_info("firmware chunk, addr: 0x%04x, len: 0x%04x, total length: 0x%04zx\n",addr,len,fw->size);
 		if ((ret = bcm3510_write_ram(st,addr,&b[i+4],len)) < 0) {
 			err("firmware download failed: %d\n",ret);
+			release_firmware(fw);
 			return ret;
 		}
 		i += 4 + len;
-- 
2.35.1

