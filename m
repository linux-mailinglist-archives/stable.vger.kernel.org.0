Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7151E66CB43
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbjAPRMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbjAPRLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:11:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4892F2B28B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D88E361037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6B1C433D2;
        Mon, 16 Jan 2023 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887929;
        bh=iJ5gAYpzP8X2I6wP90o/f3wKH74SBdM7lJNZXzn9mmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXFVC7q1kuJHufDSUVHktiPgKgMN6vHXm8KytAMRgCMbhRvEt7MUE/6gd4yORRT9K
         V3n3JBuro09yh04uYcIkdssgkjCE7VJkDvl6IgHHQpSfyyB1wKzz2U7fAdQNRe9Rd0
         +Sqvo0rA7KvClvOWRL+6nCzpGsulH7b/BRMo1KCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yan Lei <yan_lei@dahuatech.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 336/521] media: dvb-frontends: fix leak of memory fw
Date:   Mon, 16 Jan 2023 16:49:58 +0100
Message-Id: <20230116154902.208387064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



