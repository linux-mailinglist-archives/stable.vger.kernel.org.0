Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22F260FE46
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiJ0RDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiJ0RDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E06D1974F5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C412DB82716
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2032CC433C1;
        Thu, 27 Oct 2022 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890222;
        bh=AyN1dGNemw8klUM2mo4PivRWqiU0Z5zmSgMrqYFeX2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzVCEVBgMdvz75/riX8mhyoSosOWYpQIZ/xTqDnyG+UN2dwQi4gTer2G4I72gWytY
         PZ4KIwgnuxtNn/P7BB7UEjNT5lCvLeKa5vg0bgmA4apIbOiVSmfeCd/yGC3Gxq/zMW
         OPdqu2mRjKvX0TrTaQUK6EdhHRrMoDU1emBh8qu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 69/79] ksmbd: handle smb2 query dir request for OutputBufferLength that is too small
Date:   Thu, 27 Oct 2022 18:56:07 +0200
Message-Id: <20221027165057.216735311@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 65ca7a3ffff811d6c0d4342d467c381257d566d4 ]

We found the issue that ksmbd return STATUS_NO_MORE_FILES response
even though there are still dentries that needs to be read while
file read/write test using framtest utils.
windows client send smb2 query dir request included
OutputBufferLength(128) that is too small to contain even one entry.
This patch make ksmbd immediately returns OutputBufferLength of response
as zero to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 88541cb414b7 ("ksmbd: fix incorrect handling of iterate_dir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bec9a84572c0..ef0aef78eba6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3962,6 +3962,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
 
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	/*
+	 * req->OutputBufferLength is too small to contain even one entry.
+	 * In this case, it immediately returns OutputBufferLength 0 to client.
+	 */
+	if (!d_info.out_buf_len && !d_info.num_entry)
+		goto no_buf_len;
 	if (rc == 0)
 		restart_ctx(&dir_fp->readdir_data.ctx);
 	if (rc == -ENOSPC)
@@ -3988,10 +3994,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->Buffer[0] = 0;
 		inc_rfc1001_len(rsp_org, 9);
 	} else {
+no_buf_len:
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
-		d_info.data_count -= d_info.last_entry_off_align;
+		if (d_info.data_count >= d_info.last_entry_off_align)
+			d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
-- 
2.35.1



