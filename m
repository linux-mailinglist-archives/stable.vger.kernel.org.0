Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921953286D0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbhCARPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233549AbhCARI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF66365009;
        Mon,  1 Mar 2021 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616898;
        bh=VtvvIrFn9Fdr4gfVk9d/h+msCCPZnwOXf80b6+WLYAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7K33ZWIknWWjH0MpoyCJ3c+jm/+Uan6fGb7BkJ1DQwO58+5Cs6ZzkbiD5UPZph55
         V1/mo9ytYH4nMUka1lX0lwSmGOW9qz3rR3/AS2TExjI5lkR2dny1U+G2a1+RLOW7Vq
         DhGjWLLuUBkGg8dDuh/p12jj492/IJsY+P/5LgZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/247] powerpc/47x: Disable 256k page size
Date:   Mon,  1 Mar 2021 17:12:34 +0100
Message-Id: <20210301161038.227407216@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 910a0cb6d259736a0c86e795d4c2f42af8d0d775 ]

PPC47x_TLBE_SIZE isn't defined for 256k pages, leading to a build
break if 256k pages is selected.

So change the kconfig so that 256k pages can't be selected for 47x.

Fixes: e7f75ad01d59 ("powerpc/47x: Base ppc476 support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Expand change log to mention build break]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2fed79b1154c872194f98bac4422c23918325e61.1611128938.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d18ea3c1f4fac..6dd2a14e1ebcd 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -709,7 +709,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size"
-	depends on 44x && !STDBINUTILS
+	depends on 44x && !STDBINUTILS && !PPC_47x
 	help
 	  Make the page size 256k.
 
-- 
2.27.0



