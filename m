Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827F334C8B6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhC2IXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhC2IXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C3B61481;
        Mon, 29 Mar 2021 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006181;
        bh=IdFDlIIR39il2hMS2AeD6RVlsSd/FAnv32fcqcq+/AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vx5XpuuC61OGPQaL9lOfm3ag8ZO0t1t5ZTWcH7DXEp9Fi3L9ax6JF3E7vT918iQ5X
         tSjT9O6O09ypO4p8gddKEDJsWhM4Dcz1nihLNsh/IoXG6H+TUgYFLYEj3lbzy8XGrI
         gJkbYRlhJDyA8EXSEdR2HdPpkhoGIxChFJw+rbNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dillon min <dillon.minfei@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/221] ARM: dts: imx6ull: fix ubi filesystem mount failed
Date:   Mon, 29 Mar 2021 09:57:59 +0200
Message-Id: <20210329075634.107208227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dillon min <dillon.minfei@gmail.com>

[ Upstream commit e4817a1b6b77db538bc0141c3b138f2df803ce87 ]

For NAND Ecc layout, there is a dependency from old kernel's nand driver
setting and current. if old kernel use 4 bit ecc , we should use 4 bit
in new kernel either. else will run into following error at filesystem
mounting.

So, enable fsl,use-minimum-ecc from device tree, to fix this mismatch

[    9.449265] ubi0: scanning is finished
[    9.463968] ubi0 warning: ubi_io_read: error -74 (ECC error) while reading
22528 bytes from PEB 513:4096, read only 22528 bytes, retry
[    9.486940] ubi0 warning: ubi_io_read: error -74 (ECC error) while reading
22528 bytes from PEB 513:4096, read only 22528 bytes, retry
[    9.509906] ubi0 warning: ubi_io_read: error -74 (ECC error) while reading
22528 bytes from PEB 513:4096, read only 22528 bytes, retry
[    9.532845] ubi0 error: ubi_io_read: error -74 (ECC error) while reading
22528 bytes from PEB 513:4096, read 22528 bytes

Fixes: f9ecf10cb88c ("ARM: dts: imx6ull: add MYiR MYS-6ULX SBC")
Signed-off-by: dillon min <dillon.minfei@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts b/arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts
index ecbb2cc5b9ab..79cc45728cd2 100644
--- a/arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts
+++ b/arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dts
@@ -14,5 +14,6 @@
 };
 
 &gpmi {
+	fsl,use-minimum-ecc;
 	status = "okay";
 };
-- 
2.30.1



