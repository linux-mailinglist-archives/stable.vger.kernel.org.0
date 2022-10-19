Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BA603C59
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiJSIpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiJSIo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D0B89831;
        Wed, 19 Oct 2022 01:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D30AB61808;
        Wed, 19 Oct 2022 08:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC937C433D6;
        Wed, 19 Oct 2022 08:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169020;
        bh=UglnOpSZq1r0SanQA9k9gKkp/CJxtHsfjA+Q6Eod9qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDNeQbmKKIum8sHJRd0vxVEL6V836ZW8TNuFxFb9KUqbMJZQK/Aj+HpDEZ2Pl3h02
         g4MMO5AJc9SF/trqJz0vf/DwjeNqDHYNlHdyahmnlasQ2SPGgf1y7g8MeOPmx/zSgX
         vdH//FlgVLxISsmQk1XFbIBpbwrqWS4kcDk+E3v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 131/862] jbd2: fix potential buffer head reference count leak
Date:   Wed, 19 Oct 2022 10:23:38 +0200
Message-Id: <20221019083255.772010170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -925,8 +925,14 @@ int jbd2_fc_wait_bufs(journal_t *journal
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


