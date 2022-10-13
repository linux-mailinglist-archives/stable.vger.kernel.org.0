Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B055FD23C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiJMBJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiJMBIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96D6D120;
        Wed, 12 Oct 2022 18:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929CCB81CD3;
        Thu, 13 Oct 2022 00:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90795C433D6;
        Thu, 13 Oct 2022 00:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620803;
        bh=sXWczeAwZ9r6DL1uHqXq6rN4uDlFgFNAZYTK7NuL65Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJT4x6hxvCG453aVNjCqLrjFA7XmwrSBNbaWotT7qPBV+oq1JLdutAt3ZNscluU/a
         7J1X6FR1a8omPipJgph2ew67HAO/lC6oGqBjggc14Y7KUShFkNTb3DMwxasBeyo6fK
         PzsWoBHRgk7m7D+Il3151r2Vj9iDqWxkz38fEISHupku2kYnpJav1LQ7IfQpA6lzJN
         1SIqtFPcqy0/ktVXz9Gvzl/ub4pwaebPEtCJIDG0PkujCIq0vKxHByMwziwjkxlPm5
         DInYjOiww4Orjlp0w8wpbQmHiSrABshL4yQnsH5MbRrMqz4T7nePWo9KwgpzEMJlY8
         RuiY/+Wjxa5Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org,
        kuba@kernel.org, wangqing@vivo.com
Subject: [PATCH AUTOSEL 4.19 09/19] HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()
Date:   Wed, 12 Oct 2022 20:26:08 -0400
Message-Id: <20221013002623.1895576-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit b28dbcb379e6a7f80262c2732a57681b1ee548ca ]

ssip_pn_open() claims the HSI client's port with hsi_claim_port(). When
hsi_register_port_event() gets some error and returns a negetive value,
the HSI client's port should be released with hsi_release_port().

Fix it by calling hsi_release_port() when hsi_register_port_event() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/clients/ssi_protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 561abf7bdf1f..2d2175fd150f 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -942,6 +942,7 @@ static int ssip_pn_open(struct net_device *dev)
 	if (err < 0) {
 		dev_err(&cl->device, "Register HSI port event failed (%d)\n",
 			err);
+		hsi_release_port(cl);
 		return err;
 	}
 	dev_dbg(&cl->device, "Configuring SSI port\n");
-- 
2.35.1

