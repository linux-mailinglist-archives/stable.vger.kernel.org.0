Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46163D2523
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbfJJIyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389979AbfJJIub (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D684E21929;
        Thu, 10 Oct 2019 08:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697430;
        bh=OrPEpdqwd733jdhoGK9h+vv1s9G3mOo9wyJbXWHjDiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwpJHG7eQHyB/ydKb/o9upqVhOKvNSiS+SgqMAKkK5ToFhArGOeB0T9yeAk2OR7Jl
         cto3uUALBodFCTEBKlpQ+0ubKqaABpfhHtzdKpJefQO7wdlHDI4pxzhKLrVtX2MHSL
         IT5DxZNjwVpd/br89T8yKbbAnTLxVv/k3270hG+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 04/61] s390/cio: avoid calling strlen on null pointer
Date:   Thu, 10 Oct 2019 10:36:29 +0200
Message-Id: <20191010083452.173115242@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit ea298e6ee8b34b3ed4366be7eb799d0650ebe555 upstream.

Fix the following kasan finding:
BUG: KASAN: global-out-of-bounds in ccwgroup_create_dev+0x850/0x1140
Read of size 1 at addr 0000000000000000 by task systemd-udevd.r/561

CPU: 30 PID: 561 Comm: systemd-udevd.r Tainted: G    B
Hardware name: IBM 3906 M04 704 (LPAR)
Call Trace:
([<0000000231b3db7e>] show_stack+0x14e/0x1a8)
 [<0000000233826410>] dump_stack+0x1d0/0x218
 [<000000023216fac4>] print_address_description+0x64/0x380
 [<000000023216f5a8>] __kasan_report+0x138/0x168
 [<00000002331b8378>] ccwgroup_create_dev+0x850/0x1140
 [<00000002332b618a>] group_store+0x3a/0x50
 [<00000002323ac706>] kernfs_fop_write+0x246/0x3b8
 [<00000002321d409a>] vfs_write+0x132/0x450
 [<00000002321d47da>] ksys_write+0x122/0x208
 [<0000000233877102>] system_call+0x2a6/0x2c8

Triggered by:
openat(AT_FDCWD, "/sys/bus/ccwgroup/drivers/qeth/group",
		O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 16
write(16, "0.0.bd00,0.0.bd01,0.0.bd02", 26) = 26

The problem is that __get_next_id in ccwgroup_create_dev might set "buf"
buffer pointer to NULL and explicit check for that is required.

Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/ccwgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -369,7 +369,7 @@ int ccwgroup_create_dev(struct device *p
 		goto error;
 	}
 	/* Check for trailing stuff. */
-	if (i == num_devices && strlen(buf) > 0) {
+	if (i == num_devices && buf && strlen(buf) > 0) {
 		rc = -EINVAL;
 		goto error;
 	}


