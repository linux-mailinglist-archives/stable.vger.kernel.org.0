Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24396158CC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiKBC6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiKBC6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:58:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DDACE2C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9B5B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7A9C433D6;
        Wed,  2 Nov 2022 02:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357923;
        bh=dnArdGjvBDNh2D8rmeGZaGWWcfd0ZhorlSSWYZd5Goc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3A0J1g/G5LZSmuyqnW8Ujvvpk+yf/GPne6lcGBHjoBYfILv7hvVbRQ3bY95PykVK
         8ivfvZlk0NklhC46LoGYfrQ29Xm4yMqptLQWfHIuHDlkM+CRqK7DcfnvR/gQpAKR6j
         A1q4yexUv/TSQ02LnSGZ4MJsEmdH8RQnO3fBorMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Scott Mayhew <smayhew@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 002/132] NFSv4: Add an fattr allocation to _nfs4_discover_trunking()
Date:   Wed,  2 Nov 2022 03:31:48 +0100
Message-Id: <20221102022059.664849217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

commit 4f40a5b5544618b096d1611a18219dd91fd57f80 upstream.

This was missed in c3ed222745d9 ("NFSv4: Fix free of uninitialized
nfs4_label on referral lookup.") and causes a panic when mounting
with '-o trunkdiscovery':

PID: 1604   TASK: ffff93dac3520000  CPU: 3   COMMAND: "mount.nfs"
 #0 [ffffb79140f738f8] machine_kexec at ffffffffaec64bee
 #1 [ffffb79140f73950] __crash_kexec at ffffffffaeda67fd
 #2 [ffffb79140f73a18] crash_kexec at ffffffffaeda76ed
 #3 [ffffb79140f73a30] oops_end at ffffffffaec2658d
 #4 [ffffb79140f73a50] general_protection at ffffffffaf60111e
    [exception RIP: nfs_fattr_init+0x5]
    RIP: ffffffffc0c18265  RSP: ffffb79140f73b08  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff93dac304a800  RCX: 0000000000000000
    RDX: ffffb79140f73bb0  RSI: ffff93dadc8cbb40  RDI: d03ee11cfaf6bd50
    RBP: ffffb79140f73be8   R8: ffffffffc0691560   R9: 0000000000000006
    R10: ffff93db3ffd3df8  R11: 0000000000000000  R12: ffff93dac4040000
    R13: ffff93dac2848e00  R14: ffffb79140f73b60  R15: ffffb79140f73b30
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffffb79140f73b08] _nfs41_proc_get_locations at ffffffffc0c73d53 [nfsv4]
 #6 [ffffb79140f73bf0] nfs4_proc_get_locations at ffffffffc0c83e90 [nfsv4]
 #7 [ffffb79140f73c60] nfs4_discover_trunking at ffffffffc0c83fb7 [nfsv4]
 #8 [ffffb79140f73cd8] nfs_probe_fsinfo at ffffffffc0c0f95f [nfs]
 #9 [ffffb79140f73da0] nfs_probe_server at ffffffffc0c1026a [nfs]
    RIP: 00007f6254fce26e  RSP: 00007ffc69496ac8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 00007f6254fce26e
    RDX: 00005600220a82a0  RSI: 00005600220a64d0  RDI: 00005600220a6520
    RBP: 00007ffc69496c50   R8: 00005600220a8710   R9: 003035322e323231
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007ffc69496c50
    R13: 00005600220a8440  R14: 0000000000000010  R15: 0000560020650ef9
    ORIG_RAX: 00000000000000a5  CS: 0033  SS: 002b

Fixes: c3ed222745d9 ("NFSv4: Fix free of uninitialized nfs4_label on referral lookup.")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3981,18 +3981,23 @@ static int _nfs4_discover_trunking(struc
 	}
 
 	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
-	if (page == NULL || locations == NULL)
-		goto out;
+	if (!locations)
+		goto out_free;
+	locations->fattr = nfs_alloc_fattr();
+	if (!locations->fattr)
+		goto out_free_2;
 
 	status = nfs4_proc_get_locations(server, fhandle, locations, page,
 					 cred);
-	if (status)
-		goto out;
-out:
-	if (page)
-		__free_page(page);
+
+	kfree(locations->fattr);
+out_free_2:
 	kfree(locations);
+out_free:
+	__free_page(page);
 	return status;
 }
 


