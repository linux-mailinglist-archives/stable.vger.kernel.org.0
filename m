Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E804D8466
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiCNMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbiCNMVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD21513CDE;
        Mon, 14 Mar 2022 05:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92799B80DF5;
        Mon, 14 Mar 2022 12:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF2C340E9;
        Mon, 14 Mar 2022 12:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260300;
        bh=AxC3A0PHk25w6JCnEL+Q4GQPcyLNQkzIbvvI+FCuOpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwfdcMhSSF+O/WtAueaHFRtI/4w8o9TI4uFiooTHcAkVCGpGYH+wXoWsw4q90Z0wq
         S6pmLi3DnPePBn7yw9TDuoRsRpH1uuBqpgwzkKM6miQ55Sffs88cP8MJEBQgPXXS+D
         WDg7Lu4SY4NzE9Dweu6WG7j6wYP4ON6+jBj0BhOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikhil Gupta <nikhil.gupta@nxp.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 069/121] of/fdt: move elfcorehdr reservation early for crash dump kernel
Date:   Mon, 14 Mar 2022 12:54:12 +0100
Message-Id: <20220314112746.049884876@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikhil Gupta <nikhil.gupta@nxp.com>

[ Upstream commit 132507ed04ce0c5559be04dd378fec4f3bbc00e8 ]

elfcorehdr_addr is fixed address passed to Second kernel which may be conflicted
with potential reserved memory in Second kernel,so fdt_reserve_elfcorehdr() ahead
of fdt_init_reserved_mem() can relieve this situation.

Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220128042321.15228-1-nikhil.gupta@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 7e868e5995b7..f66abb496ed1 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -644,8 +644,8 @@ void __init early_init_fdt_scan_reserved_mem(void)
 	}
 
 	fdt_scan_reserved_mem();
-	fdt_init_reserved_mem();
 	fdt_reserve_elfcorehdr();
+	fdt_init_reserved_mem();
 }
 
 /**
-- 
2.34.1



