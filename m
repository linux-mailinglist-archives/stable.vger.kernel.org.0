Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22536593991
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245218AbiHOTHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245660AbiHOTGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:06:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22A64E84B;
        Mon, 15 Aug 2022 11:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB89BB8106C;
        Mon, 15 Aug 2022 18:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1237C433D6;
        Mon, 15 Aug 2022 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588476;
        bh=bzFVUVkb0hL4tUDIprYYW0i2vps8384MfZ5C8L4/c+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fizCgBQQCFR855xgKGxmmkD6t/hnYlzILT+9YbPSe66wrUFoGpl/2Ye7czR3qlH5M
         ev1D/q88KRDU9IRy4eyqOSHlU/px7dZaXX1SIUpWOvlHmcDH8drq8J+6UoVYXVSAef
         2ZOY0AC6OdSQNED/UWjFNjWbM244emDn2n6czQ+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 415/779] usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe
Date:   Mon, 15 Aug 2022 20:00:59 +0200
Message-Id: <20220815180355.002184956@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 302970b4cad3ebfda2c05ce06c322ccdc447d17e ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 73108aa90cbf ("USB: ohci-nxp: Use isp1301 driver")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220603141231.979-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-nxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index 85878e8ad331..106a6bcefb08 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -164,6 +164,7 @@ static int ohci_hcd_nxp_probe(struct platform_device *pdev)
 	}
 
 	isp1301_i2c_client = isp1301_get_client(isp1301_node);
+	of_node_put(isp1301_node);
 	if (!isp1301_i2c_client)
 		return -EPROBE_DEFER;
 
-- 
2.35.1



