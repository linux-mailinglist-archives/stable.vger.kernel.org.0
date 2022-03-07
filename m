Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6594CFA08
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiCGKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242472AbiCGKLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA5B8A321;
        Mon,  7 Mar 2022 01:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8398960C6C;
        Mon,  7 Mar 2022 09:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFB4C340E9;
        Mon,  7 Mar 2022 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646912;
        bh=pQlJEJDvqtDu+suvKnjHMbbeU6Qxo+vHXTUbe6fe3vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgJB61eUEMo21CZE7+T+kHVzNshrNZ9P9wedvzaaCtiU6hLy93Yqu/Z2wbL83L3ez
         3i4g7loxxjwac/CRSjkzQVkx0bYHN5N26sLzWgd0pg+QK74+4u4H4uScr/Zk3Hj+jU
         PE69wu16+cWxXWcEP6Qh6WX9o6aLTi5lHdeKGL7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 132/186] soc: fsl: qe: Check of ioremap return value
Date:   Mon,  7 Mar 2022 10:19:30 +0100
Message-Id: <20220307091657.769905852@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit a222fd8541394b36b13c89d1698d9530afd59a9c ]

As the possible failure of the ioremap(), the par_io could be NULL.
Therefore it should be better to check it and return error in order to
guarantee the success of the initiation.
But, I also notice that all the caller like mpc85xx_qe_par_io_init() in
`arch/powerpc/platforms/85xx/common.c` don't check the return value of
the par_io_init().
Actually, par_io_init() needs to check to handle the potential error.
I will submit another patch to fix that.
Anyway, par_io_init() itsely should be fixed.

Fixes: 7aa1aa6ecec2 ("QE: Move QE from arch/powerpc to drivers/soc")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/fsl/qe/qe_io.c b/drivers/soc/fsl/qe/qe_io.c
index e277c827bdf3..a5e2d0e5ab51 100644
--- a/drivers/soc/fsl/qe/qe_io.c
+++ b/drivers/soc/fsl/qe/qe_io.c
@@ -35,6 +35,8 @@ int par_io_init(struct device_node *np)
 	if (ret)
 		return ret;
 	par_io = ioremap(res.start, resource_size(&res));
+	if (!par_io)
+		return -ENOMEM;
 
 	if (!of_property_read_u32(np, "num-ports", &num_ports))
 		num_par_io_ports = num_ports;
-- 
2.34.1



