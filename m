Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB260B9D5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiJXUV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiJXUVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD485FF5D;
        Mon, 24 Oct 2022 11:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D78F5B815C8;
        Mon, 24 Oct 2022 12:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3158EC433B5;
        Mon, 24 Oct 2022 12:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613900;
        bh=dQ1FrTEtjY+nOpJPZkZ19Nk4MsjhXPguPPae1bpJD18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCmNqjAiq/yhacwK4WXjQMwApe4Lk8xCGbEZVyQ22ioxHmOoBJzn4Eu2j+y9sbVXr
         hROVd/kaa8yY7qgs8uoHQS5s2Oyitpv87BEPl3UO4tGx2quHBlqc7QEHCUnri8x5qM
         xbL1yrGvmYMdg9nGP7wdes6H+Zxf1CsqK+EXc6YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 057/390] jbd2: fix potential buffer head reference count leak
Date:   Mon, 24 Oct 2022 13:27:34 +0200
Message-Id: <20221024113025.065426067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit e0d5fc7a6d80ac2406c7dfc6bb625201d0250a8a upstream.

As in 'jbd2_fc_wait_bufs' if buffer isn't uptodate, will return -EIO without
update 'journal->j_fc_off'. But 'jbd2_fc_release_bufs' will release buffer head
from ‘j_fc_off - 1’ if 'bh' is NULL will terminal release which will lead to
buffer head buffer head reference count leak.
To solve above issue, update 'journal->j_fc_off' before return -EIO.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220914100812.1414768-2-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -926,8 +926,14 @@ int jbd2_fc_wait_bufs(journal_t *journal
 		wait_on_buffer(bh);
 		put_bh(bh);
 		journal->j_fc_wbuf[i] = NULL;
-		if (unlikely(!buffer_uptodate(bh)))
+		/*
+		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
+		 * buffer head.
+		 */
+		if (unlikely(!buffer_uptodate(bh))) {
+			journal->j_fc_off = i;
 			return -EIO;
+		}
 	}
 
 	return 0;


