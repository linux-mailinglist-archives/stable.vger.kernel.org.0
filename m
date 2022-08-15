Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19A4594D9D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiHPAw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244269AbiHPAtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:49:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4CBB603B;
        Mon, 15 Aug 2022 13:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E238C61241;
        Mon, 15 Aug 2022 20:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DACC433C1;
        Mon, 15 Aug 2022 20:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596382;
        bh=CPaFUPaj3NVtsuDxVI0hezS2wWYQlJAYNKy5/DDGMgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynBC6I43z0LE82FeDx21BBsWAEF7tkY/Wwul78TB2v4wGPskyfLhlUzrVNpqHKKew
         CYqIZITQXZyuXykn1yvn3arQ5nG3XrrICX+gW8uWqFqOC3qWw2eXrdL1Y6FWWzpjEP
         sZterP45916+H5m64ihboaQgzmzfDKBtX/mw95p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 1045/1157] cifs: fix lock length calculation
Date:   Mon, 15 Aug 2022 20:06:41 +0200
Message-Id: <20220815180521.834544546@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 773891ffd4d628d05c4e22f34541e4779ee7a076 upstream.

The lock length was wrongly set to 0 when fl_end == OFFSET_MAX, thus
failing to lock the whole file when l_start=0 and l_len=0.

This fixes test 2 from cthon04.

Before patch:

$ ./cthon04/lock/tlocklfs -t 2 /mnt

Creating parent/child synchronization pipes.

Test #1 - Test regions of an unlocked file.
        Parent: 1.1  - F_TEST  [               0,               1] PASSED.
        Parent: 1.2  - F_TEST  [               0,          ENDING] PASSED.
        Parent: 1.3  - F_TEST  [               0,7fffffffffffffff] PASSED.
        Parent: 1.4  - F_TEST  [               1,               1] PASSED.
        Parent: 1.5  - F_TEST  [               1,          ENDING] PASSED.
        Parent: 1.6  - F_TEST  [               1,7fffffffffffffff] PASSED.
        Parent: 1.7  - F_TEST  [7fffffffffffffff,               1] PASSED.
        Parent: 1.8  - F_TEST  [7fffffffffffffff,          ENDING] PASSED.
        Parent: 1.9  - F_TEST  [7fffffffffffffff,7fffffffffffffff] PASSED.

Test #2 - Try to lock the whole file.
        Parent: 2.0  - F_TLOCK [               0,          ENDING] PASSED.
        Child:  2.1  - F_TEST  [               0,               1] FAILED!
        Child:  **** Expected EACCES, returned success...
        Child:  **** Probably implementation error.

**  CHILD pass 1 results: 0/0 pass, 0/0 warn, 1/1 fail (pass/total).
        Parent: Child died

** PARENT pass 1 results: 10/10 pass, 0/0 warn, 0/0 fail (pass/total).

After patch:

$ ./cthon04/lock/tlocklfs -t 2 /mnt

Creating parent/child synchronization pipes.

Test #2 - Try to lock the whole file.
        Parent: 2.0  - F_TLOCK [               0,          ENDING] PASSED.
        Child:  2.1  - F_TEST  [               0,               1] PASSED.
        Child:  2.2  - F_TEST  [               0,          ENDING] PASSED.
        Child:  2.3  - F_TEST  [               0,7fffffffffffffff] PASSED.
        Child:  2.4  - F_TEST  [               1,               1] PASSED.
        Child:  2.5  - F_TEST  [               1,          ENDING] PASSED.
        Child:  2.6  - F_TEST  [               1,7fffffffffffffff] PASSED.
        Child:  2.7  - F_TEST  [7fffffffffffffff,               1] PASSED.
        Child:  2.8  - F_TEST  [7fffffffffffffff,          ENDING] PASSED.
        Child:  2.9  - F_TEST  [7fffffffffffffff,7fffffffffffffff] PASSED.
        Parent: 2.10 - F_ULOCK [               0,          ENDING] PASSED.

** PARENT pass 1 results: 2/2 pass, 0/0 warn, 0/0 fail (pass/total).

**  CHILD pass 1 results: 9/9 pass, 0/0 warn, 0/0 fail (pass/total).

Fixes: d80c69846ddf ("cifs: fix signed integer overflow when fl_end is OFFSET_MAX")
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |    4 ++--
 fs/cifs/file.c     |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2085,9 +2085,9 @@ static inline bool cifs_is_referral_serv
 	return is_tcon_dfs(tcon) || (ref && (ref->flags & DFSREF_REFERRAL_SERVER));
 }
 
-static inline u64 cifs_flock_len(struct file_lock *fl)
+static inline u64 cifs_flock_len(const struct file_lock *fl)
 {
-	return fl->fl_end == OFFSET_MAX ? 0 : fl->fl_end - fl->fl_start + 1;
+	return (u64)fl->fl_end - fl->fl_start + 1;
 }
 
 static inline size_t ntlmssp_workstation_name_size(const struct cifs_ses *ses)
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1861,9 +1861,9 @@ int cifs_lock(struct file *file, int cmd
 	rc = -EACCES;
 	xid = get_xid();
 
-	cifs_dbg(FYI, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x start: %lld end: %lld\n",
-		 cmd, flock->fl_flags, flock->fl_type,
-		 flock->fl_start, flock->fl_end);
+	cifs_dbg(FYI, "%s: %pD2 cmd=0x%x type=0x%x flags=0x%x r=%lld:%lld\n", __func__, file, cmd,
+		 flock->fl_flags, flock->fl_type, (long long)flock->fl_start,
+		 (long long)flock->fl_end);
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);


