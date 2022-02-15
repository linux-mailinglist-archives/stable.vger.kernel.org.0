Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051234B708C
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbiBOPbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:31:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240102AbiBOPa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:30:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCF0C084F;
        Tue, 15 Feb 2022 07:28:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDACDB81AF5;
        Tue, 15 Feb 2022 15:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943CCC340ED;
        Tue, 15 Feb 2022 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938933;
        bh=fT0XueLlcxFSWwJyaEOVlF8xILi9wRrnuH8+ypbp0ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkOFFmaYS5drobIUWsRt1IWcAFuljmECU9jW6UxHpXKhSqDHWZQOTb9PiprT5cY6I
         Cf3laS360Xu9LDY+fU9H4pmi1X5vPUSY1AWWkmt0zbMrvE2+v5HXZ/dmmevpYpAFbf
         V4QgdXGK2hC7FmGzZrCsnCkCuRSczNm9r+jR8tSN0I6AZ1CMGNFSUXXwoJpcNa3Ht1
         HkB0GFjEk0cWxmIONOcD6jWS/lhvC64U+hIUrABMlGb2pJqF8WH2DP5O/StNOug/zY
         RHWm2VFcgZpsNrpma5fuH6Z66tD3CpAN58gov9i01cLpXu18zyKHWM/ZwB4LRxy87y
         skItUgxIElxoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, senozhatsky@chromium.org,
        sfrench@samba.org, hyc.lee@gmail.com, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/33] ksmbd: don't align last entry offset in smb2 query directory
Date:   Tue, 15 Feb 2022 10:28:09 -0500
Message-Id: <20220215152831.580780-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

