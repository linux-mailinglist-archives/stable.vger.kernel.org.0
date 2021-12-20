Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24D47AF21
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbhLTPJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbhLTPHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:07:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA9CC025240;
        Mon, 20 Dec 2021 06:53:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84798B80EDA;
        Mon, 20 Dec 2021 14:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3778C36AEB;
        Mon, 20 Dec 2021 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012025;
        bh=PBFo5IdIuI17NDoVQiuuyTJKnUBfMi6KO25Z2PhFRQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIGfXoUaS+YmFuvnFBdySe5z5L2ceQLhpMpeSyixY5tYojoEiHhkrg4R+3Fd0aPTk
         ahnxOnuxNkWtZh+5frfhvS2ZfSV9j3rD1CYWvVeldJ+0mSJtKALYgzGHZdAUebXXBx
         GnBx+9+yw+uO+BlyoJmmiM57roOT5cuvfx20Lciw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stephan Gerhold <stephan@gerhold.net>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/177] soc: imx: Register SoC device only on i.MX boards
Date:   Mon, 20 Dec 2021 15:33:23 +0100
Message-Id: <20211220143041.886033942@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 4ebd29f91629e69da7d57390cdc953772eee03ab ]

At the moment, using the ARM32 multi_v7_defconfig always results in two
SoCs being exposed in sysfs. This is wrong, as far as I'm aware the
Qualcomm DragonBoard 410c does not actually make use of a i.MX SoC. :)

  qcom-db410c:/sys/devices/soc0$ grep . *
  family:Freescale i.MX
  machine:Qualcomm Technologies, Inc. APQ 8016 SBC
  revision:0.0
  serial_number:0000000000000000
  soc_id:Unknown

  qcom-db410c:/sys/devices/soc1$ grep . *
  family:Snapdragon
  machine:APQ8016
  ...

This happens because imx_soc_device_init() registers the soc device
unconditionally, even when running on devices that do not make use of i.MX.
Arnd already reported this more than a year ago and even suggested a fix
similar to this commit, but for some reason it was never submitted.

Fix it by checking if the "__mxc_cpu_type" variable was actually
initialized by earlier platform code. On devices without i.MX it will
simply stay 0.

Cc: Peng Fan <peng.fan@nxp.com>
Fixes: d2199b34871b ("ARM: imx: use device_initcall for imx_soc_device_init")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/CAK8P3a0hxO1TmK6oOMQ70AHSWJnP_CAq57YMOutrxkSYNjFeuw@mail.gmail.com/
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/imx/soc-imx.c b/drivers/soc/imx/soc-imx.c
index ac6d856ba228d..77bc12039c3d4 100644
--- a/drivers/soc/imx/soc-imx.c
+++ b/drivers/soc/imx/soc-imx.c
@@ -36,6 +36,10 @@ static int __init imx_soc_device_init(void)
 	int ret;
 	int i;
 
+	/* Return early if this is running on devices with different SoCs */
+	if (!__mxc_cpu_type)
+		return 0;
+
 	if (of_machine_is_compatible("fsl,ls1021a"))
 		return 0;
 
-- 
2.33.0



