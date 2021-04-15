Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7D360C30
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhDOOtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233572AbhDOOtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A5F613A9;
        Thu, 15 Apr 2021 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498126;
        bh=CdFy9NaQLEmg/PUPCmbb3Ug+hSGqUwHXpr81Mm0c7Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMm6oOC+YY3+9ZsQ9ZNmCvUl3iczQ8ApKs2nkxAfC8WOb4tDr4qbXGxGbKtzuqSyC
         MdBrt41FyUC/rxiJyF9sYb1cxAjSoZW8TnZgqynV1BNK5fVeC7LyInvT2uRDyO7w7Z
         RDNTGYSHde1PG3wtx79iyPhtDKpiNbtV5KxQz/YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.4 11/38] parisc: parisc-agp requires SBA IOMMU driver
Date:   Thu, 15 Apr 2021 16:47:05 +0200
Message-Id: <20210415144413.711976327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.352638802@linuxfoundation.org>
References: <20210415144413.352638802@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 9054284e8846b0105aad43a4e7174ca29fffbc44 upstream.

Add a dependency to the SBA IOMMU driver to avoid:
ERROR: modpost: "sba_list" [drivers/char/agp/parisc-agp.ko] undefined!

Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/agp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -124,7 +124,7 @@ config AGP_HP_ZX1
 
 config AGP_PARISC
 	tristate "HP Quicksilver AGP support"
-	depends on AGP && PARISC && 64BIT
+	depends on AGP && PARISC && 64BIT && IOMMU_SBA
 	help
 	  This option gives you AGP GART support for the HP Quicksilver
 	  AGP bus adapter on HP PA-RISC machines (Ok, just on the C8000


