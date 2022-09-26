Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED5D5EA394
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiIZL1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbiIZL0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:26:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEBC6A489;
        Mon, 26 Sep 2022 03:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8808B80688;
        Mon, 26 Sep 2022 10:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBD8C433D6;
        Mon, 26 Sep 2022 10:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188850;
        bh=3qMiBviQLJD7UsBBT4SvQ9/507KRJ/0h50pF7lkKJlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBTowmvbx667AbIZDceFdPeEstaUW7k9IebI4PFLGvqnnk9el75jrPT9rAVDsajwf
         IHd9LBpxqLCzY/E71AAr3Wf9ZPywihm4RHIbHrDGIsK9tj+zQgdktS3LtL1zkcZfzY
         kXOVgRyorVccznvRHG2d87F76gH9vF6bxmSc9soE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [PATCH 5.15 141/148] NFSv4: Fixes for nfs4_inode_return_delegation()
Date:   Mon, 26 Sep 2022 12:12:55 +0200
Message-Id: <20220926100801.499600091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 6e176d47160cec8bcaa28d9aa06926d72d54237c upstream.

We mustn't call nfs_wb_all() on anything other than a regular file.
Furthermore, we can exit early when we don't hold a delegation.

Reported-by: David Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/delegation.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -755,11 +755,13 @@ int nfs4_inode_return_delegation(struct
 	struct nfs_delegation *delegation;
 
 	delegation = nfs_start_delegation_return(nfsi);
-	/* Synchronous recall of any application leases */
-	break_lease(inode, O_WRONLY | O_RDWR);
-	nfs_wb_all(inode);
-	if (delegation != NULL)
+	if (delegation != NULL) {
+		/* Synchronous recall of any application leases */
+		break_lease(inode, O_WRONLY | O_RDWR);
+		if (S_ISREG(inode->i_mode))
+			nfs_wb_all(inode);
 		return nfs_end_delegation_return(inode, delegation, 1);
+	}
 	return 0;
 }
 


