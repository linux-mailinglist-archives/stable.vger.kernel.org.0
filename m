Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53953650373
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiLRREr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiLRRDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA6D1DA41;
        Sun, 18 Dec 2022 08:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 968B5B80BD1;
        Sun, 18 Dec 2022 16:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20A5C433EF;
        Sun, 18 Dec 2022 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380477;
        bh=iJ5gAYpzP8X2I6wP90o/f3wKH74SBdM7lJNZXzn9mmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRt+8q6apmbOggMG50L2mxhREMyaEBj8p5Z7ZrKjgTlBTVe2qignv97umHyS+IiNP
         Vp7y+2nWI2/pPdow1h4oHM7ud9XOvOpBdHa+HmnXJr21U1Nl0C3C9QBAIhAED+CEJ5
         9f3su9cU+ySu6Vevy0MSllLpk8gOP26fnrQjK+cLD2BP90CFzmObcQhhdwnHeF8Csi
         NLyFI2MiSc5dxcFjsO0NSkf/J1U1vhcLJPcn3WwdrtcLhswTFNLgHfrpMu5epHAExE
         +hD9htE2skPlF2k9OIeLMK559T3+Y+xNXY8/dQ9YudO6csr9kkx1tCwfiwHdeuvZ5V
         b5aN7mm9tCrmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yan Lei <yan_lei@dahuatech.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/26] media: dvb-frontends: fix leak of memory fw
Date:   Sun, 18 Dec 2022 11:20:09 -0500
Message-Id: <20221218162016.934280-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
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

