Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00116BB078
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjCOMSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjCOMSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6E6151F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B065261D38
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C218CC433D2;
        Wed, 15 Mar 2023 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882691;
        bh=17mih1bnqm6gwxwctscmcjfIG0xSNUDzm0j2fvCHPvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnrnBrF8ld0gV+dQbCBlknhOOYyy9BI5IJUFGduI7wIazD6NTqF8BGjl+krZ0Y6jo
         ektVqCdjncks1HVnlAHH7Wk9sjZpffKnTAtxIiRBvF3mEsZcqhcGOvFQNL/YLaXqlm
         XoKwvTh/xphmFZGift4Nh9WHBapBHk1bd1HVlNsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/68] cifs: Fix uninitialized memory read in smb3_qfs_tcon()
Date:   Wed, 15 Mar 2023 13:12:27 +0100
Message-Id: <20230315115727.393174210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volker Lendecke <vl@samba.org>

[ Upstream commit d447e794a37288ec7a080aa1b044a8d9deebbab7 ]

oparms was not fully initialized

Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a3bb2c7468c75..4cb0ebe7330eb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -823,12 +823,13 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	bool no_cached_open = tcon->nohandlecache;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	if (no_cached_open)
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
-- 
2.39.2



