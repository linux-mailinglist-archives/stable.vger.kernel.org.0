Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B7E359AE9
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhDIKG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233873AbhDIKCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B57E1611BE;
        Fri,  9 Apr 2021 10:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962413;
        bh=Xs0fslFkKVs1UjVZ/wjBXHoqz1ALUZWgpKXlyU0eOpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2dBTtL2aXvHd4H/vJc/CNwl2BsxProIDJVevLYgJwKKAF0uewKluNkUZbLnVDrz8
         YJQ0GofMoho4e79f3ekVqxLAgkpoLFN7qrwNgd6Ha+KjfUFSLAMVU5M06IOmmXkaT9
         p7QdmD9e1Czksid7/BPt0kZ6qSsPqbZezBiMfMBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 40/41] init/Kconfig: make COMPILE_TEST depend on !S390
Date:   Fri,  9 Apr 2021 11:54:02 +0200
Message-Id: <20210409095306.106159688@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
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
@@ -114,7 +114,7 @@ config INIT_ENV_ARG_LIMIT
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML
+	depends on !UML && !S390
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are


