Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA027F81F
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfD3MEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfD3Lm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B0AA21783;
        Tue, 30 Apr 2019 11:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624546;
        bh=c39czPhDGBrDcp9N/969NV5Tgs97fyFFq7kBXOprBD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e09Sds8epwpsIgVu3DzzDlGa06Ay9b4WXsdJMkoD2Tm4tMcUeFzVeXDOgN0AXp2S0
         ExYJwBCRPy3yBa6t0MxDUrPDhVHSYmOAwt9xuom+lL4Mm9s6EO2XP7nYF/HnNDMX8S
         AAR3BhNR6earzxWTqlJ/F7ST/q0gD/rm48/hc5Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Petr Mladek <pmladek@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 06/53] lib/Kconfig.debug: fix build error without CONFIG_BLOCK
Date:   Tue, 30 Apr 2019 13:38:13 +0200
Message-Id: <20190430113550.793003439@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit ae3d6a323347940f0548bbb4b17f0bb2e9164169 upstream.

If CONFIG_TEST_KMOD is set to M, while CONFIG_BLOCK is not set, XFS and
BTRFS can not be compiled successly.

Link: http://lkml.kernel.org/r/20190410075434.35220-1-yuehaibing@huawei.com
Fixes: d9c6a72d6fa2 ("kmod: add test driver to stress test the module loader")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1884,6 +1884,7 @@ config TEST_KMOD
 	depends on m
 	depends on BLOCK && (64BIT || LBDAF)	  # for XFS, BTRFS
 	depends on NETDEVICES && NET_CORE && INET # for TUN
+	depends on BLOCK
 	select TEST_LKM
 	select XFS_FS
 	select TUN


