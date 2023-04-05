Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1366D7E33
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 15:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbjDEN5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 09:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbjDEN5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 09:57:33 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EFA5B83
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 06:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1680703044; x=1712239044;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5F/jfz5jD3o9f9TTv+PJ6d4VzW2xv8KXs5pF0+UPt5o=;
  b=W+rZPWuaBQva+yQUh14A6+NO6Hv2OG6ZNjrv88Xh7h4Jrw8GavOK4T4h
   TaAC2zunPUXwPMM6iRsWxL/LzzyZRU+9WU+vObH6CiUnBXoq9Zhp9LFxW
   gJxjEe5GZZvAyb44t6xbm8vCeMZYiP3G/zclMWOPDuGvZAMSME6FziDzm
   I=;
X-IronPort-AV: E=Sophos;i="5.98,319,1673913600"; 
   d="scan'208";a="274938105"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 13:57:15 +0000
Received: from EX19D007EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 3270F60C4E;
        Wed,  5 Apr 2023 13:57:13 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 13:57:12 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 13:57:11 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 5 Apr 2023 13:57:11 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 27A9620D34; Wed,  5 Apr 2023 15:57:10 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Pratyush Yadav <ptyadav@amazon.de>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4] smb3: fix problem with null cifs super block with previous patch
Date:   Wed, 5 Apr 2023 15:57:09 +0200
Message-ID: <20230405135709.100174-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-9.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]

Add check for null cifs_sb to create_options helper

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---

Only compile-tested. This was discovered by our static code analysis
tool. I do not use CIFS and do not know how to actually reproduce the
NULL dereference.

Follow up from [0]. Original patch is at [1].

Mandatory text due to licensing terms:

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

[0] https://lore.kernel.org/stable/20230405114220.108739-1-ptyadav@amazon.de/T/#u
[1] https://lore.kernel.org/all/CAH2r5mtu69KEWU94qZK32H_8cvyhVU8GyOKrZqbdjH0ZLd95Zg@mail.gmail.com/

 fs/cifs/cifsproto.h | 2 +-
 fs/cifs/smb2ops.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a5fab9afd699f..2dde83a969680 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -602,7 +602,7 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,

 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 {
-	if (backup_cred(cifs_sb))
+	if (cifs_sb && (backup_cred(cifs_sb)))
 		return options | CREATE_OPEN_BACKUP_INTENT;
 	else
 		return options;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4cb0ebe7330eb..44a261b9850de 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2343,7 +2343,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 				      FS_FULL_SIZE_INFORMATION,
 				      SMB2_O_INFO_FILESYSTEM,
 				      sizeof(struct smb2_fs_full_size_info),
-				      &rsp_iov, &buftype, NULL);
+				      &rsp_iov, &buftype, cifs_sb);
 	if (rc)
 		goto qfs_exit;

--
2.39.2

