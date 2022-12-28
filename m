Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD766580A7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiL1QTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiL1QSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:18:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875AEB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F49B81886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4917EC433D2;
        Wed, 28 Dec 2022 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244239;
        bh=4fwTmJSony6tMREeZYaqH9q0yVlRdm4LJSLAbp406no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbODbSr4xuiO0eqMU9CSjeciUmK0kWJy4EgubavOOpgvlqi8gPeb85qztJ0qOBHvn
         1bMmPrA3+onSSXFjzy/pnuApAqTo7VG7CAABtB48eD3vsfn0ag0okuUmJKKWCjVJTP
         dqkBI8bnxrTEUmaCDKG05D59hFBL60AYUvtIhFB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0634/1146] padata: Fix list iterator in padata_do_serial()
Date:   Wed, 28 Dec 2022 15:36:13 +0100
Message-Id: <20221228144347.386429694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 57ddfecc72a6c9941d159543e1c0c0a74fe9afdd ]

list_for_each_entry_reverse() assumes that the iterated list is nonempty
and that every list_head is embedded in the same type, but its use in
padata_do_serial() breaks both rules.

This doesn't cause any issues now because padata_priv and padata_list
happen to have their list fields at the same offset, but we really
shouldn't be relying on that.

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 97f51e0c1776..de90af5fcbe6 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -390,13 +390,16 @@ void padata_do_serial(struct padata_priv *padata)
 	int hashed_cpu = padata_cpu_hash(pd, padata->seq_nr);
 	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
 	struct padata_priv *cur;
+	struct list_head *pos;
 
 	spin_lock(&reorder->lock);
 	/* Sort in ascending order of sequence number. */
-	list_for_each_entry_reverse(cur, &reorder->list, list)
+	list_for_each_prev(pos, &reorder->list) {
+		cur = list_entry(pos, struct padata_priv, list);
 		if (cur->seq_nr < padata->seq_nr)
 			break;
-	list_add(&padata->list, &cur->list);
+	}
+	list_add(&padata->list, pos);
 	spin_unlock(&reorder->lock);
 
 	/*
-- 
2.35.1



