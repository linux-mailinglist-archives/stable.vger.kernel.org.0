Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C61E60B8C1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiJXTxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiJXTwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:52:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7AC103D82;
        Mon, 24 Oct 2022 11:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01B4FB817B1;
        Mon, 24 Oct 2022 12:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F29AC433C1;
        Mon, 24 Oct 2022 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615020;
        bh=uVz+BDY/wMcdakK3a2zAGCIAkzkiJQgDSwU4vNQtw5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcyjVgyzRgv+Acfk4pL1yDKHxmVJGy0U2MIsfkUWva6JIKwgobzN0JEq7v6M3gske
         jLeMVJYLPH3ggqpuezvYo0vL41rq4CYIfThEcT1QCvUmvsKnlNyan+7mR7veqSEGpX
         lwWFYiO6rZF6FRqGzbGluf+40iILo8ObsmUDxfAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 091/530] jbd2: add miss release buffer head in fc_do_one_pass()
Date:   Mon, 24 Oct 2022 13:27:15 +0200
Message-Id: <20221024113049.129215669@linuxfoundation.org>
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

commit dfff66f30f66b9524b661f311bbed8ff3d2ca49f upstream.

In fc_do_one_pass() miss release buffer head after use which will lead
to reference count leak.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220917093805.1782845-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/recovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -256,6 +256,7 @@ static int fc_do_one_pass(journal_t *jou
 		err = journal->j_fc_replay_callback(journal, bh, pass,
 					next_fc_block - journal->j_fc_first,
 					expected_commit_id);
+		brelse(bh);
 		next_fc_block++;
 		if (err < 0 || err == JBD2_FC_REPLAY_STOP)
 			break;


