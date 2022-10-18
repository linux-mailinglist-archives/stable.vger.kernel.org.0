Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3C0601ED6
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiJRAOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiJRAOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE50DF26;
        Mon, 17 Oct 2022 17:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4AEB81BDD;
        Tue, 18 Oct 2022 00:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27488C433D7;
        Tue, 18 Oct 2022 00:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051834;
        bh=PzR8uGBQ/2Q/+FjVcBfhys6fifpKaXDT2ajW+lJBOLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSDqqBmh1LEuKU/RfF4e9UmGj/4L3b9rKTBLJlADFIg1DkqviH1n/hIA+r9wXnJnf
         Y615T7WVFSukDGK0qwrvUz6+LSHGzQym+ZTTVrNwF8cjtNMwHLpKz/CxVqSN6RlDot
         Z/v1Q6Bh3KyQA4D3c5t3j4IJZcVzCFDImnDvr593m7ARKF8/31QyMQf4nUuYUoSJBx
         u08lJoeVgvxTeaLISEZrJ9wGoiJXcUZioCWFGOtz7K/EPneC/HjxT+6w3VK89npoBG
         5XDbDwGMU8inP87CuQHdl7E/1xlPpDWRB+zjeTR+i6kPueDk8C3ic92+1TQX3VbHKa
         9EJLxf6SIRzIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 03/16] gfs2: Switch from strlcpy to strscpy
Date:   Mon, 17 Oct 2022 20:10:16 -0400
Message-Id: <20221018001029.2731620-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001029.2731620-1-sashal@kernel.org>
References: <20221018001029.2731620-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 204c0300c4e99707e9fb6e57840aa1127060e63f ]

Switch from strlcpy to strscpy and make sure that @count is the size of
the smaller of the source and destination buffers.  This prevents
reading beyond the end of the source buffer when the source string isn't
null terminated.

Found by a modified version of syzkaller.

Suggested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b9ed6a6dbcf5..f7ad3e1b26bb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -381,8 +381,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
@@ -1414,13 +1416,13 @@ static int gfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	switch (o) {
 	case Opt_lockproto:
-		strlcpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_locktable:
-		strlcpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_hostdata:
-		strlcpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_spectator:
 		args->ar_spectator = 1;
-- 
2.35.1

