Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE26650316
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiLRQ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiLRQ5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:57:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652C01C43A;
        Sun, 18 Dec 2022 08:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE04960DD4;
        Sun, 18 Dec 2022 16:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70ACC433EF;
        Sun, 18 Dec 2022 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380384;
        bh=iJ5gAYpzP8X2I6wP90o/f3wKH74SBdM7lJNZXzn9mmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plZVy4bYGUk9bxV3Z4bS05PAD4Orsrc+kY7z12oksIwckXNTCWUjHE2EuBeDWkaNT
         VS8xEQ4fD2IjgnCItG6oidjZ/pBhtV3LBXRup/09qyifZpcVA/pItrnxBwZQoC8fyf
         kHYqztRCRi2xstgVnJrkjgxuS9PJDndQzUrfdibqlNMFGpJsYa9dQNZgYGZ+c1ph9W
         2557p7vdNy6UTwsz0KA8M5yxcWXPa58Fie080N1WWGrJAENT2v+vR3tfEQpz0YN1xU
         F5RUKlyVCkms0mTM4YbSGTw2tjfNgf0LaU6ZcpCbs7zPD8GVkcBy5Exjd9TGHvtgLg
         L0AyeiWGqFBvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Lei <yan_lei@dahuatech.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/30] media: dvb-frontends: fix leak of memory fw
Date:   Sun, 18 Dec 2022 11:18:28 -0500
Message-Id: <20221218161836.933697-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161836.933697-1-sashal@kernel.org>
References: <20221218161836.933697-1-sashal@kernel.org>
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
index e92542b92d34..6457b0912d14 100644
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

