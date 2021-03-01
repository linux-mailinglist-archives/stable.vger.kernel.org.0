Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76E232844C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhCAQdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhCAQ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ACAD64E2E;
        Mon,  1 Mar 2021 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615790;
        bh=Yf2BfeoHZP+5PAt30MxiQiU/dj0IijwVsp3Mzh1RyHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYm+YtmjGrNudY7wYnja6kmb6SMBhgERRHhF8cMjbRjQ/PFio4r24hkB4CaYfAxBk
         lvMG7JiMz7FbXjMozA693zREI6RUKXacSIRhAx4cysEK44XmjKCU9LN68EbdPTKcFY
         46Zfs+FpeFyKI58qIl0xh1p0ZgUgsvm8ToHs7SCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/134] powerpc/47x: Disable 256k page size
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161016.506381970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index f529d3d9d88d7..6a06411f9bf14 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -622,7 +622,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size"
-	depends on 44x && !STDBINUTILS
+	depends on 44x && !STDBINUTILS && !PPC_47x
 	help
 	  Make the page size 256k.
 
-- 
2.27.0



