Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DD84B4AAA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbiBNKNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:13:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345711AbiBNKNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D05657A0;
        Mon, 14 Feb 2022 01:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50BBB80DC7;
        Mon, 14 Feb 2022 09:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019ACC340E9;
        Mon, 14 Feb 2022 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832282;
        bh=oaiLjJykr2FN8slW2zNpphunsPR7vSwBat8phM02CcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PC0B5xLJBwRsSKwmwSS88Icy3lIs01kbUR6Te+5Z+dZ8kTZOfTPXF1qUM7PY2YVq
         3+3wtX6/p80jC/06CQHZPWUVv2nuuSxZOz1Qmy4mVonE8KTqr8woD2DOcnUlkweKoO
         h9aX/W6D2lL1J1OWa8iK/h0dKQLS8VzAmS9nBcs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/172] NFS: Dont skip directory entries when doing uncached readdir
Date:   Mon, 14 Feb 2022 10:25:53 +0100
Message-Id: <20220214092509.682797240@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
index af7881bc6b3e6..f6381c675cbe9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1049,6 +1049,7 @@ static int uncached_readdir(struct nfs_readdir_descriptor *desc)
 		goto out;
 
 	desc->page_index = 0;
+	desc->cache_entry_index = 0;
 	desc->last_cookie = desc->dir_cookie;
 	desc->duped = 0;
 
-- 
2.34.1



