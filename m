Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD39760B152
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiJXQT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiJXQRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0739538A29;
        Mon, 24 Oct 2022 08:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06819B8162C;
        Mon, 24 Oct 2022 12:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B9EC433D6;
        Mon, 24 Oct 2022 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613905;
        bh=uVz+BDY/wMcdakK3a2zAGCIAkzkiJQgDSwU4vNQtw5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGlaruj/hGXKrkl3SQXIDjL8QikNrnJdtzuac1oMml+4Bt08Lx7+E4OsUprKH+Me0
         p/GrwQElybSWCKwtis3GjcCIcP+sD3Ms2SIZvAGxefeIvKqPREHt+fqERyRuDMrAdF
         rYz/cxJNS2sgyrSQ7c5MNthwsGQ+Zju8D1MzwrjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 059/390] jbd2: add miss release buffer head in fc_do_one_pass()
Date:   Mon, 24 Oct 2022 13:27:36 +0200
Message-Id: <20221024113025.158258028@linuxfoundation.org>
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


