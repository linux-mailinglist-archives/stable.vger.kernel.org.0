Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5546C192E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjCTPbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbjCTPbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB0233476
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1233D6157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23392C433D2;
        Mon, 20 Mar 2023 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325808;
        bh=CwC/DfTjAD4n1P+6Mrjvvs1++g9KN/D5oCL3VsQhVos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2qtnG3KdoCP0roWSBzcf8ZBt5ZsaTc71fd/N02U38fs1gDx+pKPFuM3NHLnY9sTk
         tOIoxTqlZqIa7gAP42O/u4Ofa6ZZ/9VnPPXTJlU8t8a9ieAfaPq88dJvO73JUJQpqL
         xQltPZ5znv+6GvAwg1m/hzo4omFgGg5LK5wODDPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 146/198] cifs: Fix smb2_set_path_size()
Date:   Mon, 20 Mar 2023 15:54:44 +0100
Message-Id: <20230320145513.670760175@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volker Lendecke <vl@samba.org>

commit 211baef0eabf4169ce4f73ebd917749d1a7edd74 upstream.

If cifs_get_writable_path() finds a writable file, smb2_compound_op()
must use that file's FID and not the COMPOUND_FID.

Cc: stable@vger.kernel.org
Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2inode.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -233,15 +233,32 @@ static int smb2_compound_op(const unsign
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
 
-		rc = SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+		} else {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMPOUND_FID,
+						COMPOUND_FID,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:


