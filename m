Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C784540E55
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353489AbiFGSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354520AbiFGSrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2134C880FE;
        Tue,  7 Jun 2022 11:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3FEC617A7;
        Tue,  7 Jun 2022 18:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5301C385A5;
        Tue,  7 Jun 2022 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624906;
        bh=3/dxwaV8h0U1TQVEUSuQrKCo/nqCsdi4jNTFr+Wp83g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8XIxMMaUdRMHdQ9EECseT5hqgMNlzURnT5xVGTHC0CBjhA63KPYpH+cTycYYyJyt
         TjDtPpiQk9ChWwqQKF+2cZqh8whbDpEaN6neVJlG+Ys4yYE0MfMOQHct5bQWLvRnEh
         kbcopl0VFRRplCoVkWQaJIoZiGK8xMdGHtXexZTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/667] NFS: Dont report errors from nfs_pageio_complete() more than once
Date:   Tue,  7 Jun 2022 19:02:42 +0200
Message-Id: <20220607164949.605959446@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit c5e483b77cc2edb318da152abe07e33006b975fd ]

Since errors from nfs_pageio_complete() are already being reported
through nfs_async_write_error(), we should not be returning them to the
callers of do_writepages() as well. They will end up being reported
through the generic mechanism instead.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with generic one")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index daaa4f56b074..f47cf3e8c720 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -675,11 +675,7 @@ static int nfs_writepage_locked(struct page *page,
 	err = nfs_do_writepage(page, wbc, &pgio);
 	pgio.pg_error = 0;
 	nfs_pageio_complete(&pgio);
-	if (err < 0)
-		return err;
-	if (nfs_error_is_fatal(pgio.pg_error))
-		return pgio.pg_error;
-	return 0;
+	return err;
 }
 
 int nfs_writepage(struct page *page, struct writeback_control *wbc)
@@ -737,9 +733,6 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 
 	if (err < 0)
 		goto out_err;
-	err = pgio.pg_error;
-	if (nfs_error_is_fatal(err))
-		goto out_err;
 	return 0;
 out_err:
 	return err;
-- 
2.35.1



