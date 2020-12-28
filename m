Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAAA2E3DA4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441541AbgL1OSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501901AbgL1OSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 616C62063A;
        Mon, 28 Dec 2020 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165069;
        bh=EKJnTgmYjfQDlmE4nxLKoVdPvPPIgNciSunl03w56J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haxPCvbR9ei4hb6H/GewiXvYyk+vgx0JqbirVBmQuBRDcOQe1pBjC32555ny91kAc
         fCboG6eoaX7D9IizU+Eg9wI5EU308BYMKtbi4EiVZP0k1ok/pOXI2VOr9sHZkXOnoS
         +PlEPZ1MVGWqlkJpcoDK8ChdN1kQqW1DxysjxI0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/717] remoteproc/mtk_scp: surround DT device IDs with CONFIG_OF
Date:   Mon, 28 Dec 2020 13:46:37 +0100
Message-Id: <20201228125040.108331111@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Courbot <acourbot@chromium.org>

[ Upstream commit e59aef4edc45133ccb10b8e962cb74dcf1e3240b ]

Now that this driver can be compiled with COMPILE_TEST, we have no
guarantee that CONFIG_OF will also be defined. When that happens, a
warning about mtk_scp_of_match being defined but unused will be reported
so make sure this variable is only defined if of_match_ptr() actually
uses it.

Fixes: cbd2dca74926c0e4610c40923cc786b732c9e8ef remoteproc: scp: add COMPILE_TEST dependency
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Link: https://lore.kernel.org/r/20201102074007.299222-1-acourbot@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index 577cbd5d421ec..f74f22d4d1ffc 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -772,12 +772,14 @@ static const struct mtk_scp_of_data mt8192_of_data = {
 	.host_to_scp_int_bit = MT8192_HOST_IPC_INT_BIT,
 };
 
+#if defined(CONFIG_OF)
 static const struct of_device_id mtk_scp_of_match[] = {
 	{ .compatible = "mediatek,mt8183-scp", .data = &mt8183_of_data },
 	{ .compatible = "mediatek,mt8192-scp", .data = &mt8192_of_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mtk_scp_of_match);
+#endif
 
 static struct platform_driver mtk_scp_driver = {
 	.probe = scp_probe,
-- 
2.27.0



