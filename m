Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AFF6AEF7A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjCGSXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbjCGSXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B624493E3A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5217961522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4961AC433EF;
        Tue,  7 Mar 2023 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213112;
        bh=l7Z9bg4jndwu55P5yd249FYeJsfy6mqswdoxI3LJqDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05c0kvuaj9TskMrGw1FELaSWZ3jV+423MtecM4dkjQRC6sWh1z2x0SzwIvLqL0EXo
         b50cpCmXK6peDHvQtzs6tYOLRTSi1HG1FkhJhwswdqLmEAhuMsLV/b64xKETLVtDeI
         0zJf2VeODIuqiPexdT1Jvm/erS5/Y+uz9bW8DMgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 375/885] nfsd: fix race to check ls_layouts
Date:   Tue,  7 Mar 2023 17:55:09 +0100
Message-Id: <20230307170018.623103374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit fb610c4dbc996415d57d7090957ecddd4fd64fb6 ]

Its possible for __break_lease to find the layout's lease before we've
added the layout to the owner's ls_layouts list.  In that case, setting
ls_recalled = true without actually recalling the layout will cause the
server to never send a recall callback.

Move the check for ls_layouts before setting ls_recalled.

Fixes: c5c707f96fc9 ("nfsd: implement pNFS layout recalls")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 3564d1c6f6104..e8a80052cb1ba 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -323,11 +323,11 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 	if (ls->ls_recalled)
 		goto out_unlock;
 
-	ls->ls_recalled = true;
-	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	if (list_empty(&ls->ls_layouts))
 		goto out_unlock;
 
+	ls->ls_recalled = true;
+	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	trace_nfsd_layout_recall(&ls->ls_stid.sc_stateid);
 
 	refcount_inc(&ls->ls_stid.sc_count);
-- 
2.39.2



