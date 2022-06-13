Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349A05487E3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358004AbiFMNAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357316AbiFMM6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:58:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47AA2BC8;
        Mon, 13 Jun 2022 04:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 417E2B80EBA;
        Mon, 13 Jun 2022 11:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1266C3411E;
        Mon, 13 Jun 2022 11:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119051;
        bh=7I9oYHps1lENRulcu3V187OBZAP6GOvuuPAqjStWvXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atY4NaN2lYRQXSgn4P6CpgNCDHgKBCtN4/VJSvqqZRDcdh6M7N7PzLUYtYCHhC2Q0
         MCH5D6TugwYwJrnUuoPm143dYiMA25Js2ooGSJAuwNQtBK9ncALAVKwnDqyMRCKzq2
         Lmd+oIG7ICoZz2iTD3rZOt7FxHa7CLCVpBcZdXxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/247] NFSv4: Dont hold the layoutget locks across multiple RPC calls
Date:   Mon, 13 Jun 2022 12:10:25 +0200
Message-Id: <20220613094926.693030283@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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
index 4bed3bb75ad5..cbb39aff8182 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3108,6 +3108,10 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
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



