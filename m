Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AFF300D0A
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbhAVT5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728052AbhAVOLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:11:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E889B239EF;
        Fri, 22 Jan 2021 14:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324576;
        bh=K5UVOAFSVMpxnx58cB+TImbkULMojURm5Eon9UXNVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW9eEIbpSd+9QFstRgkZ/U/83R23qB+IqfpqIFHdtNLMsCmfPjbcsOwecuBE3v4dI
         luVKCMpQiy6jCkFN4bmiH+CRChlwfnOrxcQ0Hh9bf35dsUjpWwzcxxXQimP6BatbEd
         /Rg5q/gdON5OOxuHySqtCU7h8C4zNJ7mRPsVayc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/31] misdn: dsp: select CONFIG_BITREVERSE
Date:   Fri, 22 Jan 2021 15:08:22 +0100
Message-Id: <20210122135732.210359401@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 51049bd903a81307f751babe15a1df8d197884e8 ]

Without this, we run into a link error

arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o: in function `dsp_audio_generate_law_tables':
(.text+0x30c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/isdn/mISDN/dsp_audio.o:(.text+0x5e4): more undefined references to `byte_rev_table' follow

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index c0730d5c734d6..fb61181a5c4f7 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -12,6 +12,7 @@ if MISDN != n
 config MISDN_DSP
 	tristate "Digital Audio Processing of transparent data"
 	depends on MISDN
+	select BITREVERSE
 	help
 	  Enable support for digital audio processing capability.
 
-- 
2.27.0



