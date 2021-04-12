Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3435BF49
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbhDLJDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237296AbhDLJBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3961961369;
        Mon, 12 Apr 2021 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218006;
        bh=A6NMrUo9PzqV0g+b+1ZLkVLe2KvddtC4M4PTT5zRk5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct/UHrswBejFbPIqItgScKX8xEk23HmW65HDgGU+tWTfOeiCMRMnQYi4O4Ql2bv5C
         lxYEFCjfmI8Ni3iTqPlcnDOn1Y+X64KXBwpzygAGLJiGsnKTZ6PT12dflEmsFlLbBA
         XAiuNACOYEgcy53IqbGnQJbgWxbpcgH8FJH2Nyc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.11 036/210] parisc: parisc-agp requires SBA IOMMU driver
Date:   Mon, 12 Apr 2021 10:39:01 +0200
Message-Id: <20210412084017.212121142@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -125,7 +125,7 @@ config AGP_HP_ZX1
 
 config AGP_PARISC
 	tristate "HP Quicksilver AGP support"
-	depends on AGP && PARISC && 64BIT
+	depends on AGP && PARISC && 64BIT && IOMMU_SBA
 	help
 	  This option gives you AGP GART support for the HP Quicksilver
 	  AGP bus adapter on HP PA-RISC machines (Ok, just on the C8000


