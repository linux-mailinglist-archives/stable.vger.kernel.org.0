Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD3E66C4A6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjAPP5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjAPP4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA6923873
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE5661042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D76C433F2;
        Mon, 16 Jan 2023 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884597;
        bh=UOYZVzsz4sHHWxo/TzPiAXAEMO3oShLbeC5mYHnj0XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0TkM+96I9gtlsMZphaSD29tGIZvlDJKRruqnElpH6Fxo5FT5BXc39HLZWZluONJn
         m0g7NatW7Nceq7kY55A7bGSfcVsc1vr93X2Cccno1QVvCwinOi36wSt76ORvGsLGMu
         lH1ZrbdAx2Qd+MM4g7HEdf270TPKS3CZP+fhX4RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 039/183] cifs: fix file info setting in cifs_query_path_info()
Date:   Mon, 16 Jan 2023 16:49:22 +0100
Message-Id: <20230116154805.027598454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 29cf28235e3e57e0af01ae29db57a75f87a2ada8 upstream.

We missed to set file info when CIFSSMBQPathInfo() returned 0, thus
leaving cifs_open_info_data::fi unset.

Fix this by setting cifs_open_info_data::fi when either
CIFSSMBQPathInfo() or SMBQueryInformation() succeed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216881
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb1ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 50480751e521..5fe2c2f8ef41 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -562,17 +562,20 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, &fi, cifs_sb->local_nls,
 					 cifs_remap(cifs_sb));
-		if (!rc)
-			move_cifs_info_to_smb2(&data->fi, &fi);
 		*adjustTZ = true;
 	}
 
-	if (!rc && (le32_to_cpu(fi.Attributes) & ATTR_REPARSE)) {
+	if (!rc) {
 		int tmprc;
 		int oplock = 0;
 		struct cifs_fid fid;
 		struct cifs_open_parms oparms;
 
+		move_cifs_info_to_smb2(&data->fi, &fi);
+
+		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
+			return 0;
+
 		oparms.tcon = tcon;
 		oparms.cifs_sb = cifs_sb;
 		oparms.desired_access = FILE_READ_ATTRIBUTES;
-- 
2.39.0



