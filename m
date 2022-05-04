Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1474F51A63F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353955AbiEDQyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354208AbiEDQx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738948394;
        Wed,  4 May 2022 09:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 561506176E;
        Wed,  4 May 2022 16:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F20C385AA;
        Wed,  4 May 2022 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682952;
        bh=g9pPF97d+RCHJOFXbQh0ZKnmjNdrs3ToH0uMgEVpXfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzgrRMhuP28y6cuukQMpwdmgZZbFuvSGE8DEtGIWH/2N1Mg9pPpGEZ56Bph1ZRJMc
         sDclXVBAfWqshnksw/RlfPG/aAQWiGDzdo5BeW10TJbiAa91LVYvIDOH+u0D64dUiF
         H6pEy8uFp5aglh6OKJj7gcXt9KlG67FAgw3dQ420=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 71/84] cifs: destage any unwritten data to the server before calling copychunk_write
Date:   Wed,  4 May 2022 18:44:52 +0200
Message-Id: <20220504152932.993640135@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index defee1d208d2..7985fe25850b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1643,9 +1643,17 @@ smb2_copychunk_range(const unsigned int xid,
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



