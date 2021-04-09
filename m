Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC1359A5A
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhDIJ6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233267AbhDIJ5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC55611F0;
        Fri,  9 Apr 2021 09:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962216;
        bh=oOB4KvLI0LtOeCzvt1vwlcxK/hlJXgS2GjokpbsK7gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y4m/T0LwIBJfisNboL9KWZDNFXKIFR3onUdMwWpuH3Ajigf+5VpsbRkDX2bA7sZp3
         EPs2gV1mus3LJyEiMWIAv78WiAgN/uYDYrRIft+sUZHIXqcem/S7gclOEzXTtvyGLC
         O9lA132hYnMQjoqk1KN7T8FzzjXIXd5g+FnYPXXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 17/18] init/Kconfig: make COMPILE_TEST depend on !S390
Date:   Fri,  9 Apr 2021 11:53:45 +0200
Message-Id: <20210409095302.092147858@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
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
@@ -66,7 +66,7 @@ config INIT_ENV_ARG_LIMIT
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML
+	depends on !UML && !S390
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are


