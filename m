Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8C510876
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353566AbiDZTGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353798AbiDZTFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77B61999D4;
        Tue, 26 Apr 2022 12:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6706C619C0;
        Tue, 26 Apr 2022 19:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43B0C385C0;
        Tue, 26 Apr 2022 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999758;
        bh=Fibnfz6UKMUBj//0u9tJTPvRAWqgcl6ZhEU2wPNikR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lub7iSDHdAVPAxBmSK4C7cmvLZyXsWzUfpjEwKPQKyQhZn4yTDCh9eYDFF797i06c
         i47FV6GLRutgeWfBuHf8r1s2QGuXuMRB3bk2HprZhz5cUMPgCCWjZu5Ek6wrK+SUY3
         02o8f76l/7JubbHr/b35QwkKqUIDBaJrT6k1SEKzrsFNn6ivPz7qtVOp9akDRrGLJ6
         mTaRjCEeGKdBF6Pa8Zj7Ot0JhFtt2Pg/4wAIPQTsxaeUcOGImvZKmaXRHKRf4c146x
         WK5j3VcQyeZqQc5YUAb40PIykJv201ecPngq3kXErdr5DTqYm7OIEA2FAhhDSpJcV5
         YGLdFP9ia4bpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Xiaoli Feng <xifeng@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 6/9] cifs: destage any unwritten data to the server before calling copychunk_write
Date:   Tue, 26 Apr 2022 15:02:27 -0400
Message-Id: <20220426190232.2351606-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190232.2351606-1-sashal@kernel.org>
References: <20220426190232.2351606-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit f5d0f921ea362636e4a2efb7c38d1ead373a8700 ]

because the copychunk_write might cover a region of the file that has not yet
been sent to the server and thus fail.

A simple way to reproduce this is:
truncate -s 0 /mnt/testfile; strace -f -o x -ttT xfs_io -i -f -c 'pwrite 0k 128k' -c 'fcollapse 16k 24k' /mnt/testfile

the issue is that the 'pwrite 0k 128k' becomes rearranged on the wire with
the 'fcollapse 16k 24k' due to write-back caching.

fcollapse is implemented in cifs.ko as a SMB2 IOCTL(COPYCHUNK_WRITE) call
and it will fail serverside since the file is still 0b in size serverside
until the writes have been destaged.
To avoid this we must ensure that we destage any unwritten data to the
server before calling COPYCHUNK_WRITE.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1997373
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0e8f484031da..c758ff41b638 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1744,9 +1744,17 @@ smb2_copychunk_range(const unsigned int xid,
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
+	struct inode *inode;
 
 	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
 
+	/*
+	 * We need to flush all unwritten data before we can send the
+	 * copychunk ioctl to the server.
+	 */
+	inode = d_inode(trgtfile->dentry);
+	filemap_write_and_wait(inode->i_mapping);
+
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
-- 
2.35.1

