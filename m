Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15C96089ED
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiJVIpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiJVInv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322B82EA963;
        Sat, 22 Oct 2022 01:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598D2B82E21;
        Sat, 22 Oct 2022 08:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76D8C433C1;
        Sat, 22 Oct 2022 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425955;
        bh=fSjG4RXvpX46fKNLE6mDdtR1CXfA7oy7Me+/3xuP4Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAeXce0CnTyjnWKBMabAn5950XUBzBJN5HO0rri0U/i/r7BhJ3QvilGYaj5oAtUo2
         UMQA7cqOZJemRTZlgUomHsxh2olJ5/dTpX8alkdQfwP5l8exr+75eO1FMtb9gk/nK+
         DifXB/bk9srExLIa4iCOU5mFZ59Bu8AuLIi1hMxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 671/717] HSI: ssi_protocol: fix potential resource leak in ssip_pn_open()
Date:   Sat, 22 Oct 2022 09:29:10 +0200
Message-Id: <20221022072528.112564165@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



