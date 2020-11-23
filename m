Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D572C0B17
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbgKWMhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731987AbgKWMhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62BC22203;
        Mon, 23 Nov 2020 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135063;
        bh=CNiP+4Hj3vw6UmF5OummcB34I0ZbFbNNqimg2SA/Qck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbYyFxYx9zsF9B7BazhOEw5ZmzNUEg4LHSgHjn/D/1zs2tg84HMNVKljwA+Pxvi7F
         uuK1nnGcUBLz8TeSK30E2PfHXdFGXQq4dH8EEq9qAX20/8lO/Hj/lpJdAFSLx0DPVp
         Frg3dgdHs0n6cV+wsvdbInhJ6MK49xAQ5ADobgTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/158] MIPS: export has_transparent_hugepage() for modules
Date:   Mon, 23 Nov 2020 13:21:29 +0100
Message-Id: <20201123121822.882979950@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 31b4d8e172f614adc53ddecb4b6b2f6411a49b84 ]

MIPS should export its local version of "has_transparent_hugepage"
so that loadable modules (dax) can use it.

Fixes this build error:
ERROR: modpost: "has_transparent_hugepage" [drivers/dax/dax.ko] undefined!

Fixes: fd8cfd300019 ("arch: fix has_transparent_hugepage()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index c13e46ced4252..60046445122b3 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -437,6 +437,7 @@ int has_transparent_hugepage(void)
 	}
 	return mask == PM_HUGE_MASK;
 }
+EXPORT_SYMBOL(has_transparent_hugepage);
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
 
-- 
2.27.0



