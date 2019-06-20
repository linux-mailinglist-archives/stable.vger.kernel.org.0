Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691CC4D607
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfFTSDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbfFTSDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011DF21655;
        Thu, 20 Jun 2019 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053813;
        bh=QFpOEXXW0FjTm7dhG4KwD1l7Bk6rjye07FM0QSmow6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXm/VXwXp9MTVbWYnTvNGfoe4e8jG3U/NjLyCM+L2gfpKifLll3FMM/eVF1mRjrln
         C2kHILqHOSYLU9JGYouH2Bh+bXcYGWw/AXW/APm+iAlnho0732zggRQo5h/hUgmZmN
         N8Ihm+MiaqL1sKLAbeHZ7VPFGIt7d4Su/+u4iaxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 035/117] soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher
Date:   Thu, 20 Jun 2019 19:56:09 +0200
Message-Id: <20190620174354.094825607@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 89e28da82836530f1ac7a3a32fecc31f22d79b3e ]

When building with -Wsometimes-uninitialized, Clang warns:

drivers/soc/mediatek/mtk-pmic-wrap.c:1358:6: error: variable 'rdata' is
used uninitialized whenever '||' condition is true
[-Werror,-Wsometimes-uninitialized]

If pwrap_write returns non-zero, pwrap_read will not be called to
initialize rdata, meaning that we will use some random uninitialized
stack value in our print statement. Zero initialize rdata in case this
happens.

Link: https://github.com/ClangBuiltLinux/linux/issues/401
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-pmic-wrap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/mediatek/mtk-pmic-wrap.c b/drivers/soc/mediatek/mtk-pmic-wrap.c
index e929f5142862..36226976773f 100644
--- a/drivers/soc/mediatek/mtk-pmic-wrap.c
+++ b/drivers/soc/mediatek/mtk-pmic-wrap.c
@@ -778,7 +778,7 @@ static bool pwrap_is_pmic_cipher_ready(struct pmic_wrapper *wrp)
 static int pwrap_init_cipher(struct pmic_wrapper *wrp)
 {
 	int ret;
-	u32 rdata;
+	u32 rdata = 0;
 
 	pwrap_writel(wrp, 0x1, PWRAP_CIPHER_SWRST);
 	pwrap_writel(wrp, 0x0, PWRAP_CIPHER_SWRST);
-- 
2.20.1



