Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D19144253
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbfFMQVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbfFMIiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:38:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D370721721;
        Thu, 13 Jun 2019 08:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415131;
        bh=oxMuwjtktYkxiK9sd1zMzgf0XzAJf1R4ngfEY3DRXtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7aXyva+DlUnmafakCFVmj5t+MogfFmME6uxoS+8NFnkTP4hxZb/1pRJjX2H1WTAz
         tZeIKV0uHdR1lFp9fEo2QMKBPFMIRya/zVGd4EkctjBaCgd+DrSHNm5/PwGa+Xkb+0
         Do8FTFetJvgnZeBVoO48n0/rQAiKaZStXzbTEJnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/118] mm/hmm: select mmu notifier when selecting HMM
Date:   Thu, 13 Jun 2019 10:32:25 +0200
Message-Id: <20190613075644.104278652@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 734fb89968900b5c5f8edd5038bd4cdeab8c61d2 ]

To avoid random config build issue, select mmu notifier when HMM is
selected.  In any cases when HMM get selected it will be by users that
will also wants the mmu notifier.

Link: http://lkml.kernel.org/r/20190403193318.16478-2-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index de64ea658716..b457e94ae618 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -700,12 +700,12 @@ config DEV_PAGEMAP_OPS
 
 config HMM
 	bool
+	select MMU_NOTIFIER
 	select MIGRATE_VMA_HELPER
 
 config HMM_MIRROR
 	bool "HMM mirror CPU page table into a device page table"
 	depends on ARCH_HAS_HMM
-	select MMU_NOTIFIER
 	select HMM
 	help
 	  Select HMM_MIRROR if you want to mirror range of the CPU page table of a
-- 
2.20.1



