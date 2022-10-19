Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1056043E6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiJSLxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJSLwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:52:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71A24D26E;
        Wed, 19 Oct 2022 04:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2668CE21C2;
        Wed, 19 Oct 2022 09:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE1CC433D7;
        Wed, 19 Oct 2022 09:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170864;
        bh=fSjG4RXvpX46fKNLE6mDdtR1CXfA7oy7Me+/3xuP4Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKX77W1NPLH1iClqT2yqdCl01XZ+soa03y+WKH1xrGX1Dkv2o5pyY+0y/kkYF8q57
         y87yY81xSUjBjWH0KV9D/V7qfMGkGegEt3espi04xYWCGXRONHOqkKkDa48tL0kmkL
         5l4D35awjrFeIjNFWDEp66UX+UsGDG+4pTlTurGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 814/862] HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()
Date:   Wed, 19 Oct 2022 10:35:01 +0200
Message-Id: <20221019083325.888317761@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 21f11a5b965b..49ffd808d17f 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -931,6 +931,7 @@ static int ssip_pn_open(struct net_device *dev)
 	if (err < 0) {
 		dev_err(&cl->device, "Register HSI port event failed (%d)\n",
 			err);
+		hsi_release_port(cl);
 		return err;
 	}
 	dev_dbg(&cl->device, "Configuring SSI port\n");
-- 
2.35.1



