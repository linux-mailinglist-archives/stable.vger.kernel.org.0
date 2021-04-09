Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDE359A34
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhDIJ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhDIJ4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20BFB611C1;
        Fri,  9 Apr 2021 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962165;
        bh=55GvB+ZBPGH92rbkSluyz0cHnOKe5To3V3NJBZFj5zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqwN7EpPTjZeJzHLZ9WTsx504J6mc18XPho8TPJZky4Eerll0eHYeA6iovV+dtwTv
         9FKpBcxV0J/DjS+SCVRpuepjJm1Kuy6moZUBod9RzArM63utlHgKZemgK/IfuAIRkZ
         WSOZBV66fzpOK5uKhhv9PvAsv8aEEN9jqhHmq4V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 13/14] init/Kconfig: make COMPILE_TEST depend on !S390
Date:   Fri,  9 Apr 2021 11:53:38 +0200
Message-Id: <20210409095300.824087653@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095300.391558233@linuxfoundation.org>
References: <20210409095300.391558233@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 334ef6ed06fa1a54e35296b77b693bcf6d63ee9e upstream.

While allmodconfig and allyesconfig build for s390 there are also
various bots running compile tests with randconfig, where PCI is
disabled. This reveals that a lot of drivers should actually depend on
HAS_IOMEM.
Adding this to each device driver would be a never ending story,
therefore just disable COMPILE_TEST for s390.

The reasoning is more or less the same as described in
commit bc083a64b6c0 ("init/Kconfig: make COMPILE_TEST depend on !UML").

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -65,7 +65,7 @@ config CROSS_COMPILE
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML
+	depends on !UML && !S390
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are


