Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE563DF09
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiK3SnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiK3SnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EAEEB7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BCB061D6A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD9AC433C1;
        Wed, 30 Nov 2022 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833780;
        bh=X9pQl7qPJKt05DQwZOx/8QIpcMaJKUUJ9Xb+hErQcoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyc+8gJtjZsvRX8JysR5O6bSuz/z999Fv7e3NescKz3lJZVlPvh4VkUJw2beNMtUF
         QLvIdS6cPmRnlcPSIYib8Dcw7RQqJGcdbwLLiJzNvjcCUoWLTfn8YNNj1Lvl02G0io
         yHo7dXWXAKOwBznMHqe1wU5+NvD6zWBIqgKf8qko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 012/289] selftests/net: dont tests batched TCP io_uring zc
Date:   Wed, 30 Nov 2022 19:19:57 +0100
Message-Id: <20221130180544.412360280@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9921d5013a6e51892623bf2f1c5b49eaecda55ac ]

It doesn't make sense batch submitting io_uring requests to a single TCP
socket without linking or some other kind of ordering. Moreover, it
causes spurious -EINTR fails due to interaction with task_work. Disable
it for now and keep queue depth=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/io_uring_zerocopy_tx.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 32aa6e9dacc2..9ac4456d48fc 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -29,7 +29,7 @@ if [[ "$#" -eq "0" ]]; then
 	for IP in "${IPs[@]}"; do
 		for mode in $(seq 1 3); do
 			$0 "$IP" udp -m "$mode" -t 1 -n 32
-			$0 "$IP" tcp -m "$mode" -t 1 -n 32
+			$0 "$IP" tcp -m "$mode" -t 1 -n 1
 		done
 	done
 
-- 
2.35.1



