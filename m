Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80C548E66
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378712AbiFMNq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379279AbiFMNn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:43:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3053F334;
        Mon, 13 Jun 2022 04:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015F8B80E59;
        Mon, 13 Jun 2022 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD5C34114;
        Mon, 13 Jun 2022 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119914;
        bh=tGBlJ7JY+s3B2/qOb54Hys5f330KW69tkUwoYC4ttqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VUuNy2635MEfkFBWjdjPVOARutxL+9tcawq7+iSVdMNNOG6GsxbUl1FtpyQFoeuZ
         bJf2pMsuWMbJMxDznasNpZ/lOhslw2A8jK024Oha7ibyFc/MCoMnlAVGTjvD1LaFrn
         1y/VjtOLIPmVU82861v8Lmou4Hp/TtwRBlyAINAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trond Myklebust <trondmy@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 184/339] NFSD: Fix potential use-after-free in nfsd_file_put()
Date:   Mon, 13 Jun 2022 12:10:09 +0200
Message-Id: <20220613094932.258210982@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b6c71c66b0ad8f2b59d9bc08c7a5079b110bec01 ]

nfsd_file_put_noref() can free @nf, so don't dereference @nf
immediately upon return from nfsd_file_put_noref().

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 999397926ab3 ("nfsd: Clean up nfsd_file_put()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 2c1b027774d4..0326bdec5de7 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -306,11 +306,12 @@ nfsd_file_put(struct nfsd_file *nf)
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
-	} else {
+	} else if (nf->nf_file) {
 		nfsd_file_put_noref(nf);
-		if (nf->nf_file)
-			nfsd_file_schedule_laundrette();
-	}
+		nfsd_file_schedule_laundrette();
+	} else
+		nfsd_file_put_noref(nf);
+
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
 }
-- 
2.35.1



