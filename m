Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEAA13FDD0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391311AbgAPX3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391305AbgAPX3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0555920748;
        Thu, 16 Jan 2020 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217376;
        bh=KGDcDbAGyfFPVnBKXB4mUdrlWdRDNcL4M6TEXQLB4eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opHpqAupR0jO+1ozatLWkcLHWetf6Z520TkjvgNKVARQlyAmI9+auPmb0ROqnuLRc
         mHKSUqG9t2/rwbm3QzAKOqjWhpAlLaGMQZgInBf4ZTavrbK8aHgy6s0co3TAhymVS0
         A4GwAdGA/qMHNgRJfKHCImcfBYMdQQ+bIaOWRmaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carsten Jacobi <jacobi@de.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jonathan Billings <jsbillings@jsbillings.org>,
        Todd DeSantis <atd@us.ibm.com>
Subject: [PATCH 4.19 31/84] afs: Fix missing cell comparison in afs_test_super()
Date:   Fri, 17 Jan 2020 00:18:05 +0100
Message-Id: <20200116231717.380111014@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 106bc79843c3c6f4f00753d1f46e54e815f99377 upstream.

Fix missing cell comparison in afs_test_super().  Without this, any pair
volumes that have the same volume ID will share a superblock, no matter the
cell, unless they're in different network namespaces.

Normally, most users will only deal with a single cell and so they won't
see this.  Even if they do look into a second cell, they won't see a
problem unless they happen to hit a volume with the same ID as one they've
already got mounted.

Before the patch:

    # ls /afs/grand.central.org/archive
    linuxdev/  mailman/  moin/  mysql/  pipermail/  stage/  twiki/
    # ls /afs/kth.se/
    linuxdev/  mailman/  moin/  mysql/  pipermail/  stage/  twiki/
    # cat /proc/mounts | grep afs
    none /afs afs rw,relatime,dyn,autocell 0 0
    #grand.central.org:root.cell /afs/grand.central.org afs ro,relatime 0 0
    #grand.central.org:root.archive /afs/grand.central.org/archive afs ro,relatime 0 0
    #grand.central.org:root.archive /afs/kth.se afs ro,relatime 0 0

After the patch:

    # ls /afs/grand.central.org/archive
    linuxdev/  mailman/  moin/  mysql/  pipermail/  stage/  twiki/
    # ls /afs/kth.se/
    admin/        common/  install/  OldFiles/  service/  system/
    bakrestores/  home/    misc/     pkg/       src/      wsadmin/
    # cat /proc/mounts | grep afs
    none /afs afs rw,relatime,dyn,autocell 0 0
    #grand.central.org:root.cell /afs/grand.central.org afs ro,relatime 0 0
    #grand.central.org:root.archive /afs/grand.central.org/archive afs ro,relatime 0 0
    #kth.se:root.cell /afs/kth.se afs ro,relatime 0 0

Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Carsten Jacobi <jacobi@de.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Jonathan Billings <jsbillings@jsbillings.org>
cc: Todd DeSantis <atd@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -356,6 +356,7 @@ static int afs_test_super(struct super_b
 	return (as->net_ns == as1->net_ns &&
 		as->volume &&
 		as->volume->vid == as1->volume->vid &&
+		as->cell == as1->cell &&
 		!as->dyn_root);
 }
 


