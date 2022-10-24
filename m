Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCD460AC47
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbiJXOF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbiJXOCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F94480510;
        Mon, 24 Oct 2022 05:48:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1932E61297;
        Mon, 24 Oct 2022 12:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DD9C433D6;
        Mon, 24 Oct 2022 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615015;
        bh=dQ1FrTEtjY+nOpJPZkZ19Nk4MsjhXPguPPae1bpJD18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GISi8huXxz9sQOP1Xcv2h1cUWZhezWqrovBUQOw1kS0wpSTThy1tOQquV9BubcVsy
         r/zRWuOxfCB5zINE96cM++y2WiE6966NHgOj0goF860UaNri/rF4DbglnHiUhZs4j+
         Wndq0xrkW9cEtF41ecyIhsmS8td/qQuHU2eQPijw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 089/530] jbd2: fix potential buffer head reference count leak
Date:   Mon, 24 Oct 2022 13:27:13 +0200
Message-Id: <20221024113049.039697524@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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


