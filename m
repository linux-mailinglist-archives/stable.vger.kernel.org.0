Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1843540E56
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbiFGSyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354505AbiFGSrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C964E7892C;
        Tue,  7 Jun 2022 11:01:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86F9FB82340;
        Tue,  7 Jun 2022 18:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFC1C385A5;
        Tue,  7 Jun 2022 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624895;
        bh=bz52bsbaM6Hv1aMArof1Cr4y5A+L8T1VCZm51MIedRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkPm6bQA1bVCpM59FgJDsC4BsWcUEo1xZtsuFL7THN+ydj5xZWWDZRBOognq3Y/I+
         8gs9Y0mp2qm7sMOwo62kaKVKVkCbpFe77Sg3WU7CmI11a2PJDnXCKpEyNE8QiAn4LD
         cvb4+ZIsdIRCzlHdF7xSerpvhedzZgxht2KFrWG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/667] NFS: Do not report EINTR/ERESTARTSYS as mapping errors
Date:   Tue,  7 Jun 2022 19:02:38 +0200
Message-Id: <20220607164949.485255350@linuxfoundation.org>
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

[ Upstream commit cea9ba7239dcc84175041174304c6cdeae3226e5 ]

If the attempt to flush data was interrupted due to a local signal, then
just requeue the writes back for I/O.

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with generic one")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index d21b25511499..daaa4f56b074 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1419,7 +1419,7 @@ static void nfs_async_write_error(struct list_head *head, int error)
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
-		if (nfs_error_is_fatal(error))
+		if (nfs_error_is_fatal_on_server(error))
 			nfs_write_error(req, error);
 		else
 			nfs_redirty_request(req);
-- 
2.35.1



