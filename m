Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7984B4B6E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348096AbiBNKen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiBNKeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B52A2F09;
        Mon, 14 Feb 2022 02:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E54A9B80DCF;
        Mon, 14 Feb 2022 10:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AD3C340EF;
        Mon, 14 Feb 2022 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832843;
        bh=LUObdx/tC5/QG984k54QexGkrfBeyynXLCwdcNtP95k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB3zImC4yHFtxtmaVShU/9uFhpg2q2V6qmtg7pDpT81zKZyfX0hG/x3LaHSFaqLF4
         q4Orwx4HWDH8akYtjaFMGhlv9bV49I0LTurlR0wlGPtpGvSXs1ryVCUCrP1Pj6uV28
         1YWuvJCROnbma3CQ3bEp9lWjXMRoMrdn5HXOSXL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 111/203] NFS: Dont skip directory entries when doing uncached readdir
Date:   Mon, 14 Feb 2022 10:25:55 +0100
Message-Id: <20220214092514.020217823@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: trondmy@kernel.org <trondmy@kernel.org>

[ Upstream commit ce292d8faf41f62e0fb0c78476c6fce5d629235a ]

Ensure that we initialise desc->cache_entry_index correctly in
uncached_readdir().

Fixes: d1bacf9eb2fd ("NFS: add readdir cache array")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 13740f1e3972e..63d7da0b7e32c 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1041,6 +1041,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 		goto out;
 
 	desc->page_index = 0;
+	desc->cache_entry_index = 0;
 	desc->last_cookie = desc->dir_cookie;
 	desc->duped = 0;
 
-- 
2.34.1



