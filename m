Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C914CF58E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiCGJaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbiCGJ2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F412A6A029;
        Mon,  7 Mar 2022 01:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BF7460C00;
        Mon,  7 Mar 2022 09:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4148CC340E9;
        Mon,  7 Mar 2022 09:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645111;
        bh=8HVQ0bK50UVVZlUYGGpvPde5Jchndo2Q57B4WADFTzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJzM/LJjNj35ADtw1nDmYkqdMH82iRqHDjgd54O1AbNI6PHt3C9qgaIFF1B4JUlWf
         FNqglt/UgSCDAMtmbQSxic+wljz3cA061dqg0AQ+9G6/M8yF1tJRb32bnDivcKfI4J
         qJMs4YN7rXIWUrv6pYICYpUqKNfn9HHs/s0IvaKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/51] soc: fsl: qe: Check of ioremap return value
Date:   Mon,  7 Mar 2022 10:19:17 +0100
Message-Id: <20220307091638.188796141@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
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
index 7ae59abc7863..127a4a836e67 100644
--- a/drivers/soc/fsl/qe/qe_io.c
+++ b/drivers/soc/fsl/qe/qe_io.c
@@ -41,6 +41,8 @@ int par_io_init(struct device_node *np)
 	if (ret)
 		return ret;
 	par_io = ioremap(res.start, resource_size(&res));
+	if (!par_io)
+		return -ENOMEM;
 
 	num_ports = of_get_property(np, "num-ports", NULL);
 	if (num_ports)
-- 
2.34.1



