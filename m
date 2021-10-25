Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13C43A27B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhJYTtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237753AbhJYTp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A38611AE;
        Mon, 25 Oct 2021 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190773;
        bh=x78di4Y7cau7oQeUDkoo6UR9fiq7T4VUxl685vD7tkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2GorxHfUzq1wPWvRMsH+a5EIrG29etv8trXzgAOPQAd8uI6GdgzvXuMHWwLagAog
         WXVd/k/gUF6p8FaK8sVi9upnRiRf4E6AJ+AHbHMFALLNAXs9aKckgNi32BAxuaJEOb
         tdjbDcEKCYuhm18LNqJcKYVfnOCq31j6C2bqj8P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-um@lists.infradead.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        linux-hams@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 038/169] hamradio: baycom_epp: fix build for UML
Date:   Mon, 25 Oct 2021 21:13:39 +0200
Message-Id: <20211025191022.696563287@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0a9bb11a5e298e72b675255a4bb2893513000584 ]

On i386, the baycom_epp driver wants to inspect X86 CPU features (TSC)
and then act on that data, but that info is not available when running
on UML, so prevent that test and do the default action.

Prevents this build error on UML + i386:

../drivers/net/hamradio/baycom_epp.c: In function ‘epp_bh’:
../drivers/net/hamradio/baycom_epp.c:630:6: error: implicit declaration of function ‘boot_cpu_has’; did you mean ‘get_cpu_mask’? [-Werror=implicit-function-declaration]
  if (boot_cpu_has(X86_FEATURE_TSC))   \
      ^
../drivers/net/hamradio/baycom_epp.c:658:2: note: in expansion of macro ‘GETTICK’
  GETTICK(time1);

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-hams@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/baycom_epp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 4435a1195194..8ea8d50f81c4 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -623,16 +623,16 @@ static int receive(struct net_device *dev, int cnt)
 
 /* --------------------------------------------------------------------- */
 
-#ifdef __i386__
+#if defined(__i386__) && !defined(CONFIG_UML)
 #include <asm/msr.h>
 #define GETTICK(x)						\
 ({								\
 	if (boot_cpu_has(X86_FEATURE_TSC))			\
 		x = (unsigned int)rdtsc();			\
 })
-#else /* __i386__ */
+#else /* __i386__  && !CONFIG_UML */
 #define GETTICK(x)
-#endif /* __i386__ */
+#endif /* __i386__  && !CONFIG_UML */
 
 static void epp_bh(struct work_struct *work)
 {
-- 
2.33.0



