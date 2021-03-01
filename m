Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B412328F3C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242040AbhCATsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233421AbhCATf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:35:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 853C765047;
        Mon,  1 Mar 2021 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619106;
        bh=Q1Gt/h04qLVfGsVVVe+VRIucfDa5xdIzWfKEKP87pjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy2gXMwOLXSgjaJ04kOIwrIEasgSpsLFGDBHIjJaoZjuZD0r20tbfw+frVpua8qGB
         pmzUhCXqMj2m7/adJvDb9wR/wMwg4K8BdQKsCretH12BUrd+/5z5V6dgmR1Y3/3H7t
         YxXqAuj4EgNzYA458MPSa6Dybi5Q4OpUsi7phOKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/663] powerpc/47x: Disable 256k page size
Date:   Mon,  1 Mar 2021 17:09:34 +0100
Message-Id: <20210301161157.980094995@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 5181872f94523..31ed8083571ff 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -761,7 +761,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size"
-	depends on 44x && !STDBINUTILS
+	depends on 44x && !STDBINUTILS && !PPC_47x
 	help
 	  Make the page size 256k.
 
-- 
2.27.0



