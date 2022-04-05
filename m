Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9CD4F2C2A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiDEI3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D34825FA;
        Tue,  5 Apr 2022 01:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8172B81B90;
        Tue,  5 Apr 2022 08:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A96C385A2;
        Tue,  5 Apr 2022 08:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146572;
        bh=Uuc8TI2J6LCVOUkBalK+gztZd5pAzXYyYOxYGnUtsdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2KeLeVvLOWY/k3dZdJhDAj07Xzj8XTre9F3oCi13Dq+bhh9xTbYa/YvlLyCREd0F
         c2cEzsdRCT+IM7aRcygzMb83vEqzjbt1H8fPkCwjRYGbIV6ckmvllbA420uLxigGtw
         1plICUY689F3UQjtBDITJr5DH1LnAC54XuRa0pCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <aglo@umich.edu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0813/1126] NFS: Dont loop forever in nfs_do_recoalesce()
Date:   Tue,  5 Apr 2022 09:26:00 +0200
Message-Id: <20220405070431.427748233@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d02d81efc7564b4d5446a02e0214a164cf00b1f3 ]

If __nfs_pageio_add_request() fails to add the request, it will return
with either desc->pg_error < 0, or mirror->pg_recoalesce will be set, so
we are guaranteed either to exit the function altogether, or to loop.

However if there is nothing left in mirror->pg_list to coalesce, we must
exit, so make sure that we clear mirror->pg_recoalesce every time we
loop.

Reported-by: Olga Kornievskaia <aglo@umich.edu>
Fixes: 70536bf4eb07 ("NFS: Clean up reset of the mirror accounting variables")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pagelist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index ad7f83dc9a2d..815d63080245 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1218,6 +1218,7 @@ static int nfs_do_recoalesce(struct nfs_pageio_descriptor *desc)
 
 	do {
 		list_splice_init(&mirror->pg_list, &head);
+		mirror->pg_recoalesce = 0;
 
 		while (!list_empty(&head)) {
 			struct nfs_page *req;
-- 
2.34.1



