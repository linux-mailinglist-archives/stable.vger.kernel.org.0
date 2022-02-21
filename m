Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173044BDE9A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350757AbiBUJja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351465AbiBUJhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:37:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91C39B8F;
        Mon, 21 Feb 2022 01:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F0DD60E05;
        Mon, 21 Feb 2022 09:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9FBC340E9;
        Mon, 21 Feb 2022 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434950;
        bh=fT0XueLlcxFSWwJyaEOVlF8xILi9wRrnuH8+ypbp0ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2Nmwz7MW0bRv3KE7puJ0GxNbKHRaFvyTufSTcHXigq/dr4hSprT6FnjcQovHfohu
         DqR+1enXcHSGsBN1DuolqD1azQcXkCthaxqXzYJkD66dP0WQ7BoMT7IQF4IbCPUPeB
         uMXXCkzybEOUa4lpPOpxkjvgFlLtc9QjCwrStnho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/196] ksmbd: dont align last entry offset in smb2 query directory
Date:   Mon, 21 Feb 2022 09:49:48 +0100
Message-Id: <20220221084936.161922677@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 04e260948a160d3b7d622bf4c8a96fa4577c09bd ]

When checking smb2 query directory packets from other servers,
OutputBufferLength is different with ksmbd. Other servers add an unaligned
next offset to OutputBufferLength for the last entry.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 7 ++++---
 fs/ksmbd/vfs.h     | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 70685cbbec8c0..192d8308afc27 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3422,9 +3422,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		goto free_conv_name;
 	}
 
-	struct_sz = readdir_info_level_struct_sz(info_level);
-	next_entry_offset = ALIGN(struct_sz - 1 + conv_len,
-				  KSMBD_DIR_INFO_ALIGNMENT);
+	struct_sz = readdir_info_level_struct_sz(info_level) - 1 + conv_len;
+	next_entry_offset = ALIGN(struct_sz, KSMBD_DIR_INFO_ALIGNMENT);
+	d_info->last_entry_off_align = next_entry_offset - struct_sz;
 
 	if (next_entry_offset > d_info->out_buf_len) {
 		d_info->out_buf_len = 0;
@@ -3976,6 +3976,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
+		d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index b0d5b8feb4a36..432c947731779 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -86,6 +86,7 @@ struct ksmbd_dir_info {
 	int		last_entry_offset;
 	bool		hide_dot_file;
 	int		flags;
+	int		last_entry_off_align;
 };
 
 struct ksmbd_readdir_data {
-- 
2.34.1



