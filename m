Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC1C360CEC
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhDOOzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhDOOyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:54:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B4F613DD;
        Thu, 15 Apr 2021 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498365;
        bh=A6NMrUo9PzqV0g+b+1ZLkVLe2KvddtC4M4PTT5zRk5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXzBDqLH07hFfMOihQnsHMULWOBmgYjnMxEIH27G4teINNUJnt7+ZzExGUrKtz79V
         FqzOK+fJl8ZwTodd/wspyBrpQB5dFNyHqvXhqWZ9XsWyNbfWm7FI1LjkVPAqbO2JGM
         y/zEIg3e58nhQlJUzb6uO/dLgQtVTCXayDKQKP0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 12/68] parisc: parisc-agp requires SBA IOMMU driver
Date:   Thu, 15 Apr 2021 16:46:53 +0200
Message-Id: <20210415144414.867840761@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
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


