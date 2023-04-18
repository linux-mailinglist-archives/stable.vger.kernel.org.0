Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2F6E61D7
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjDRM2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjDRM2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A6E1993
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA026311D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F5DC433D2;
        Tue, 18 Apr 2023 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820794;
        bh=Ys3OuZ4JtmAeZJTaOuI3LluCDz3hvhlfGj6ux60KLuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4tbRXGS+d6S2CP4KiLwNEOqniUvsbix5B/g59T73U9NTQneJOWdukH1ehK4HnKVy
         7/ssDwxICHb1722P6/XtJPcZZfQ92a5uHq4s2oiFbGTXEiEd/WrVJ8raczYQ/VSc1+
         TI2ZJGScNKWVGBOk9XqyEotZ4NUwWkRUIBXYMBGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/57] NFSv4: Check the return value of update_open_stateid()
Date:   Tue, 18 Apr 2023 14:21:06 +0200
Message-Id: <20230418120258.941556756@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e3c8dc761ead061da2220ee8f8132f729ac3ddfe ]

Ensure that we always check the return value of update_open_stateid()
so that we can retry if the update of local state failed. This fixes
infinite looping on state recovery.

Fixes: e23008ec81ef3 ("NFSv4 reduce attribute requests for open reclaim")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v3.7+
Stable-dep-of: 6165a16a5ad9 ("NFSv4: Fix hangs when recovering open state after a server reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4f8775d9d0f06..70150894ed77f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1862,8 +1862,9 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
 update:
-	update_open_stateid(state, &data->o_res.stateid, NULL,
-			    data->o_arg.fmode);
+	if (!update_open_stateid(state, &data->o_res.stateid,
+				NULL, data->o_arg.fmode))
+		return ERR_PTR(-EAGAIN);
 	refcount_inc(&state->count);
 
 	return state;
@@ -1928,8 +1929,11 @@ _nfs4_opendata_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-	update_open_stateid(state, &data->o_res.stateid, NULL,
-			data->o_arg.fmode);
+	if (!update_open_stateid(state, &data->o_res.stateid,
+				NULL, data->o_arg.fmode)) {
+		nfs4_put_open_state(state);
+		state = ERR_PTR(-EAGAIN);
+	}
 out:
 	nfs_release_seqid(data->o_arg.seqid);
 	return state;
-- 
2.39.2



