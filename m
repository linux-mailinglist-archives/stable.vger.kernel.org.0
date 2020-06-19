Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71222015A8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbgFSOyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389820AbgFSOyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:54:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D13721556;
        Fri, 19 Jun 2020 14:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578448;
        bh=uCNmxVWLAvd2UD6qMLaucpPVHNdoLiyvb7ceBA1576o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKY5Hb/+KQ1Nl6wpiR7XZrx7ymy1EUd5K6Uy6vxk+UzuV2TiHV7sP3M28le+lv6OR
         mUlLWaJTyvCa9EGOGyZKg1zpckfUyoSyMmCs8CRKVaLQ+/jSw0ApPA8BavEYM3QVvJ
         2zJ8jIbPD0zyZqYmrd282g6rFQveKEU2vn8UTqOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stafford Horne <shorne@gmail.com>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 4.19 009/267] arch/openrisc: Fix issues with access_ok()
Date:   Fri, 19 Jun 2020 16:29:54 +0200
Message-Id: <20200619141649.312635166@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

commit 9cb2feb4d21d97386eb25c7b67e2793efcc1e70a upstream.

The commit 594cc251fdd0 ("make 'user_access_begin()' do 'access_ok()'")
exposed incorrect implementations of access_ok() macro in several
architectures.  This change fixes 2 issues found in OpenRISC.

OpenRISC was not properly using parenthesis for arguments and also using
arguments twice.  This patch fixes those 2 issues.

I test booted this patch with v5.0-rc1 on qemu and it's working fine.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/include/asm/uaccess.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/openrisc/include/asm/uaccess.h
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -58,8 +58,12 @@
 /* Ensure that addr is below task's addr_limit */
 #define __addr_ok(addr) ((unsigned long) addr < get_fs())
 
-#define access_ok(type, addr, size) \
-	__range_ok((unsigned long)addr, (unsigned long)size)
+#define access_ok(type, addr, size)						\
+({ 									\
+	unsigned long __ao_addr = (unsigned long)(addr);		\
+	unsigned long __ao_size = (unsigned long)(size);		\
+	__range_ok(__ao_addr, __ao_size);				\
+})
 
 /*
  * These are the main single-value transfer routines.  They automatically


