Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468B14B71B5
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiBOP1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:27:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbiBOP1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:27:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A451A6534;
        Tue, 15 Feb 2022 07:27:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 353BCB81AEE;
        Tue, 15 Feb 2022 15:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0480C340F1;
        Tue, 15 Feb 2022 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938841;
        bh=eEcLGIVXMQkyu6JpN7qeQfTNgzp08OYhHxab6htHh+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoeMTptsUwapHYv5S0B5rvy+uVrNqFXKGdOPFpOZyqr+d6ILMg6FdXhSRUNsla0TX
         aisxu5wIgGc03Jwfw0w0J2N0fjLt3Z2BOlkuoSZp+HYP2tELtvUYp3eEcAzXYXkSsf
         91ucIyj6zs3v/vD0/fnm7iQgQhL1Q2GKLXzDVa9s1wQch3S7egHwOpJW+YJyyiWm7o
         pizUrWgfeNZnDD6vReXzdo1Bj9CEtAoGGqaqkvrqtlrDcc6V872tsL9T4EJucuruBt
         NiCE+G9CzSnxgfWBg4/i+njR0oMFaCqMfegEkkF6nYQBMNIazpu6U/pxWUEIznvQh7
         T60rxYXfNZRgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, senozhatsky@chromium.org,
        sfrench@samba.org, hyc.lee@gmail.com, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 11/34] ksmbd: don't align last entry offset in smb2 query directory
Date:   Tue, 15 Feb 2022 10:26:34 -0500
Message-Id: <20220215152657.580200-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
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
index 1ff1e52f398fc..cbbbccdc5a0a5 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3423,9 +3423,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
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
@@ -3977,6 +3977,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
+		d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index adf94a4f22fa6..8c37aaf936ab1 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -47,6 +47,7 @@ struct ksmbd_dir_info {
 	int		last_entry_offset;
 	bool		hide_dot_file;
 	int		flags;
+	int		last_entry_off_align;
 };
 
 struct ksmbd_readdir_data {
-- 
2.34.1

