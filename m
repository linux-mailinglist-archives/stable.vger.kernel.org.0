Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2822E14D4F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfEFOuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbfEFOtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:49:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005D4205ED;
        Mon,  6 May 2019 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154184;
        bh=Ssz7bAFJmMrMEk3bUWNjS3aKTLjX0TpE0Llhx7ykABY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qumWqKWfjYqJpe6yA9RswFvzCytobXicg2cOodIrU3CLS18l4ePeh5khqGBoWD1u
         WWxoN/ahyqQ0jYTMflf6fco1eFASKGq3GytYfuhpHYmt3yd0ihV24H3ldnZN0huVz0
         +GW4GJX8acxTTgQmKIeJ5mE6vnyzLvsPaPVwwXl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Taylor <louis@kragniz.eu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 43/62] vfio/pci: use correct format characters
Date:   Mon,  6 May 2019 16:33:14 +0200
Message-Id: <20190506143054.928200753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 426b046b748d1f47e096e05bdcc6fb4172791307 ]

When compiling with -Wformat, clang emits the following warnings:

drivers/vfio/pci/vfio_pci.c:1601:5: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                ^~~~~~

drivers/vfio/pci/vfio_pci.c:1601:13: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                        ^~~~~~

drivers/vfio/pci/vfio_pci.c:1601:21: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                                ^~~~~~~~~

drivers/vfio/pci/vfio_pci.c:1601:32: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                                           ^~~~~~~~~

drivers/vfio/pci/vfio_pci.c:1605:5: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                ^~~~~~

drivers/vfio/pci/vfio_pci.c:1605:13: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                        ^~~~~~

drivers/vfio/pci/vfio_pci.c:1605:21: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                                ^~~~~~~~~

drivers/vfio/pci/vfio_pci.c:1605:32: warning: format specifies type
      'unsigned short' but the argument has type 'unsigned int' [-Wformat]
                                vendor, device, subvendor, subdevice,
                                                           ^~~~~~~~~
The types of these arguments are unconditionally defined, so this patch
updates the format character to the correct ones for unsigned ints.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Louis Taylor <louis@kragniz.eu>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7338e43faa17..f9a75df2d22d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1467,11 +1467,11 @@ static void __init vfio_pci_fill_ids(void)
 		rc = pci_add_dynid(&vfio_pci_driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
-			pr_warn("failed to add dynamic id [%04hx:%04hx[%04hx:%04hx]] class %#08x/%08x (%d)\n",
+			pr_warn("failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
 				vendor, device, subvendor, subdevice,
 				class, class_mask, rc);
 		else
-			pr_info("add [%04hx:%04hx[%04hx:%04hx]] class %#08x/%08x\n",
+			pr_info("add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
 				vendor, device, subvendor, subdevice,
 				class, class_mask);
 	}
-- 
2.20.1



