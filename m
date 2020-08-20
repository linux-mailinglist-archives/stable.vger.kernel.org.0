Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01524B358
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgHTJqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgHTJqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:46:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5176A2173E;
        Thu, 20 Aug 2020 09:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916760;
        bh=ML6MeKfHJFdmd/j6R4VH8tkXe+Fr/873m/BBU9B4WKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZPM40Z/POvPJarO+koj9fWhcrXnjlpwlZH9gdzg6Yrutw495mQAI1qr6Zqzgcs1Y
         6QuaMw91C3IGFChZ52IdswTQ3yPOeEHhtQ9IvUdEHQAHN4YdMq83/S3tnakjk1mC5T
         paiL+23kDP+JSXMlm+iRgDaem1v9QPQA35xvEPy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 036/152] powerpc/ptdump: Fix build failure in hashpagetable.c
Date:   Thu, 20 Aug 2020 11:20:03 +0200
Message-Id: <20200820091555.506820739@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 7c466b0807960edc13e4b855be85ea765df9a6cd upstream.

H_SUCCESS is only defined when CONFIG_PPC_PSERIES is defined.

!= H_SUCCESS means != 0. Modify the test accordingly.

Fixes: 65e701b2d2a8 ("powerpc/ptdump: drop non vital #ifdefs")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/795158fc1d2b3dff3bf7347881947a887ea9391a.1592227105.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/ptdump/hashpagetable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/ptdump/hashpagetable.c
+++ b/arch/powerpc/mm/ptdump/hashpagetable.c
@@ -259,7 +259,7 @@ static int pseries_find(unsigned long ea
 	for (i = 0; i < HPTES_PER_GROUP; i += 4, hpte_group += 4) {
 		lpar_rc = plpar_pte_read_4(0, hpte_group, (void *)ptes);
 
-		if (lpar_rc != H_SUCCESS)
+		if (lpar_rc)
 			continue;
 		for (j = 0; j < 4; j++) {
 			if (HPTE_V_COMPARE(ptes[j].v, want_v) &&


