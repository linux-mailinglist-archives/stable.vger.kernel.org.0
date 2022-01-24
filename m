Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D9649969F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358388AbiAXVFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53582 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444404AbiAXVAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D62B96135E;
        Mon, 24 Jan 2022 21:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C19C340E5;
        Mon, 24 Jan 2022 21:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058051;
        bh=Z0DFj+IIA3ZacqhuK/HbkR0W3oq/NemNEIJFwRpukc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wXlWcS4Kn1JSOKUgzxBLFOfy2DJdqqOxWYjYneHrLVKOuDYZq17z0MsapiNMdSmA
         U7Ge25Jj1BRygFn8wnUhXjB2cCKW5d31RwZUpKOofREhCpw9850uGTgasmwS3ds4qH
         w9uR1xFMKlrSoYKbg+iOrIRj+gRJGL0D11FPN09I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0166/1039] soc: imx: gpcv2: keep i.MX8MM VPU-H1 bus clock active
Date:   Mon, 24 Jan 2022 19:32:35 +0100
Message-Id: <20220124184130.802467525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 8361b8b29f9389084b679db854cf733375c64763 ]

Enable the vpu-h1 clock when the domain is active because reading
or writing to the VPU-H1 IP block cause the system to hang.

Fixes: 656ade7aa42a ("soc: imx: gpcv2: keep i.MX8M* bus clocks enabled")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index b8d52d8d29dbb..7b6dfa33dcb9f 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -734,6 +734,7 @@ static const struct imx_pgc_domain imx8mm_pgc_domains[] = {
 			.map = IMX8MM_VPUH1_A53_DOMAIN,
 		},
 		.pgc   = BIT(IMX8MM_PGC_VPUH1),
+		.keep_clocks = true,
 	},
 
 	[IMX8MM_POWER_DOMAIN_DISPMIX] = {
-- 
2.34.1



