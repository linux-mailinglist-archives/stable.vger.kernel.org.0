Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76A314C14
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfEFOgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbfEFOgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E379D204EC;
        Mon,  6 May 2019 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153368;
        bh=ZaoHcNUgs5GV+vfouf2QElCN36BBMQpSYciQTVvDVzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6Ls1Hrff7uQiPy/r1SJRqRnoTFu+PmOnvxcVK04Sue+YO9RP898OIhwzQtsNrliu
         I5JSa66ebgSvdJQkBan3he7mNE6G45UcPscKxY+vG+Uqs/dwDBT14ZGmac+J86GNvI
         gyq7nn5cez1+LyGr908RZik/++hT+GDyLaVo6VeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Taylor <louis@kragniz.eu>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 062/122] vfio/pci: use correct format characters
Date:   Mon,  6 May 2019 16:32:00 +0200
Message-Id: <20190506143100.534917596@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
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
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ff60bd1ea587..eb8fc8ccffc6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1597,11 +1597,11 @@ static void __init vfio_pci_fill_ids(void)
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



