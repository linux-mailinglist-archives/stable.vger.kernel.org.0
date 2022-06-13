Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED7654868F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378338AbiFMNmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378351AbiFMNlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:41:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ABC2317C;
        Mon, 13 Jun 2022 04:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755B8B80EAA;
        Mon, 13 Jun 2022 11:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA18FC3411C;
        Mon, 13 Jun 2022 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119873;
        bh=b1DJiWExFcr0kAeHgHNyhBwXgzK04ggOYj3POLI0jMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKuhfCghV79kKYWfaAu29sAU8lEsPR69oPNdvKF0GbeJ2RQfOY6j3zwK3KlQKH3i4
         VwoImvjX0KUBd+zT9cyf5brQDQo7Ad8ZnX50iwZqTIxDmUPuyrPyqJiKvKQLhO0+II
         Mcmh1DYzUHs+vImJdndP+3SV1Nsnhzzb+zoNitXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 169/339] NFSv4: Dont hold the layoutget locks across multiple RPC calls
Date:   Mon, 13 Jun 2022 12:09:54 +0200
Message-Id: <20220613094931.805983543@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6949493884fe88500de4af182588e071cf1544ee ]

When doing layoutget as part of the open() compound, we have to be
careful to release the layout locks before we can call any further RPC
calls, such as setattr(). The reason is that those calls could trigger
a recall, which could deadlock.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8c5907287c16..d1eaaeb7f713 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3098,6 +3098,10 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	}
 
 out:
+	if (opendata->lgp) {
+		nfs4_lgopen_release(opendata->lgp);
+		opendata->lgp = NULL;
+	}
 	if (!opendata->cancelled)
 		nfs4_sequence_free_slot(&opendata->o_res.seq_res);
 	return ret;
-- 
2.35.1



