Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103B46D7BC9
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbjDELoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237295AbjDELoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:44:10 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59DA6191
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 04:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1680695024; x=1712231024;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yEEbqIHbJ2Q7C7Ovj6gBdia6NIMCaeuoyosg0qxNrIs=;
  b=NW+caurfF7/uboQGZ4wwNfHy+Xyg9nLIuO2i1T0yn/iLOUBXXKT6yjSb
   AFR8qs4TMS+T5DFpKiNUwY3i0axkGqz0koQ3ChonUed/sJkiAhE7lCp5x
   F1ryhRSmRSojtPnx7TY7fYH6g3kJAvDgjJizzHMwpL4/bE6KQzN03qwls
   I=;
X-IronPort-AV: E=Sophos;i="5.98,319,1673913600"; 
   d="scan'208";a="317047722"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 11:42:50 +0000
Received: from EX19D002EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 659E58533C;
        Wed,  5 Apr 2023 11:42:48 +0000 (UTC)
Received: from EX19D028EUC001.ant.amazon.com (10.252.61.241) by
 EX19D002EUA003.ant.amazon.com (10.252.50.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 11:42:46 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D028EUC001.ant.amazon.com (10.252.61.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 11:42:45 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 5 Apr 2023 11:42:45 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 3F45A22BC6; Wed,  5 Apr 2023 13:42:44 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     <stable@vger.kernel.org>
CC:     Pratyush Yadav <ptyadav@amazon.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>, Amir Goldstein <amir73il@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in smb2_query_info_compound()
Date:   Wed, 5 Apr 2023 13:42:20 +0200
Message-ID: <20230405114220.108739-1-ptyadav@amazon.de>
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

smb2_queryfs() calls smb2_query_info_compound() with cifs_sb set to
NULL. It is then dereferenced by cifs_create_options(). Commit
a6e44cb21534d ("SMB3: Backup intent flag missing from some more ops")
removed the NULL check before dereferencing cifs_sb. Add it back.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: a6e44cb21534d ("SMB3: Backup intent flag missing from some more ops")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---

Only compile-tested. I do not know this code very well. This was pointed
out by our static code analysis tool.

 fs/cifs/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4cb0ebe7330eb..04256edaa4f73 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2272,7 +2272,10 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.tcon = tcon;
 	oparms.desired_access = desired_access;
 	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
+	if (cifs_sb)
+		oparms.create_options = cifs_create_options(cifs_sb, 0);
+	else
+		oparms.create_options = 0;
 	oparms.fid = &fid;
 	oparms.reconnect = false;

--
2.39.2

