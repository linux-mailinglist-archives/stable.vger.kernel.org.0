Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049984CF5C9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiCGJaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbiCGJ3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E28113F3D;
        Mon,  7 Mar 2022 01:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFC0AB810B2;
        Mon,  7 Mar 2022 09:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38622C340E9;
        Mon,  7 Mar 2022 09:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645323;
        bh=WU7VEYy0Xc05GwsC1IyWX6WMTSMSrLs5PDAjEwVz1SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yklWV4ETKmf+PL/28dzMUyygvjiZ0eWdzxplTdWVSWxk2WISLcCUF+s4QQpONbthy
         TjWWE13mZbbOdiIalhn2+bIsqQ7z5sriEI7d1Wtz+7g7p0TUkfVksViApdc7Ssg+dw
         jf+MvxnGs1JZoJ0xOiKB4OwpgBsmdJXlZSWBx1cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/64] soc: fsl: qe: Check of ioremap return value
Date:   Mon,  7 Mar 2022 10:19:24 +0100
Message-Id: <20220307091640.599507239@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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
index 3657e296a8a2..058c2fec9a4b 100644
--- a/drivers/soc/fsl/qe/qe_io.c
+++ b/drivers/soc/fsl/qe/qe_io.c
@@ -37,6 +37,8 @@ int par_io_init(struct device_node *np)
 	if (ret)
 		return ret;
 	par_io = ioremap(res.start, resource_size(&res));
+	if (!par_io)
+		return -ENOMEM;
 
 	num_ports = of_get_property(np, "num-ports", NULL);
 	if (num_ports)
-- 
2.34.1



