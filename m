Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87500566DA0
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiGEMY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiGEMVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:21:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B9E1EAFE;
        Tue,  5 Jul 2022 05:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED54F61A94;
        Tue,  5 Jul 2022 12:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03878C341C7;
        Tue,  5 Jul 2022 12:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023396;
        bh=tgcEEObmjWIoRo4+RmcNJHwzZmd8PbTCFr5gDg2ruiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldysNu6+WlyUZpsAoK/YcyI87T5X4aGu3Pq5jmuPasIccdWVM+pGgBULnUQ1AzAns
         b0aV87yPnF2hDaLCzBMNEPVy2U4geGebPVTfjaPc92Q+kimJUXyY3YaTyZ/mHkEiYt
         DEbzhxKMDtsVoj3jerlYo9iZUzz5qh+874I9Up94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.18 046/102] NFSv4: Add an fattr allocation to _nfs4_discover_trunking()
Date:   Tue,  5 Jul 2022 13:58:12 +0200
Message-Id: <20220705115619.716969254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c0fdcf8c0032..bb0e84a46d61 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4012,22 +4012,29 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
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
 	if (status)
-		goto out;
+		goto out_free_3;
 
 	for (i = 0; i < locations->nlocations; i++)
 		test_fs_location_for_trunking(&locations->locations[i], clp,
 					      server);
-out:
-	if (page)
-		__free_page(page);
+out_free_3:
+	kfree(locations->fattr);
+out_free_2:
 	kfree(locations);
+out_free:
+	__free_page(page);
 	return status;
 }
 
-- 
2.37.0



