Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B6C601F63
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiJRASY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiJRAQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913C487FA9;
        Mon, 17 Oct 2022 17:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 246AA61321;
        Tue, 18 Oct 2022 00:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D6EC4314B;
        Tue, 18 Oct 2022 00:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051786;
        bh=/hjzGar/0VgP2RwhyPQpVluClcs4W1C5SKsXzcFFZuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7eDhmzYkCICg6P4EWbB3FVtJyS2K4gVKPWBMnL2r1dJ/qntdPb6vM1XhuE7ui2dW
         BxRNkR1OMCOUpYc/zJOTElEv8cNcuREDO/Rk0x2dawlPOYQeumWJ1jx8Bc23KrC10Y
         RBtQjLBeUT/ATUqAgibvhpYyL4FcbLQpnnDPh4AKcWvpw19psq8Nvfwumd3Z5nauzD
         LQF1gA3fyfaf7AKsrWzvIKyOIVJps4RY7T3UI9ANjmNlzxIg7KQcEEJFpV6szLKjdw
         310urm4ePrD2f0spCT7ec4umX5P3YWk3tNhNQFyG6G5qZnx27rOsUwFPYQkFqRcV9h
         MqF56iqldUM/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 03/21] gfs2: Switch from strlcpy to strscpy
Date:   Mon, 17 Oct 2022 20:09:22 -0400
Message-Id: <20221018000940.2731329-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
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
index 7f8410d8fdc1..f461a365eb38 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -385,8 +385,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
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
@@ -1443,13 +1445,13 @@ static int gfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
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

