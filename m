Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3470058BF5D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242221AbiHHBid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242509AbiHHBhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:37:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F8DE009;
        Sun,  7 Aug 2022 18:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233D160DB9;
        Mon,  8 Aug 2022 01:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41120C433C1;
        Mon,  8 Aug 2022 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922424;
        bh=Yjb9Y4qVJPHM6/fkJw0FSZx+TJgkUbWAT0nB14c/RKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO+otVEVkSvJcuhpZhruXEbo6TDr1gFDAgG442ZNxHXxFd4ezDVX7bkZTjgfQynHS
         oAcSLwosib1pQnpMZD9KHKmlSHU0LREWdpVjBirTtJN3p4qfIWbliTdCewxF5cetFY
         mXvGFYT2RLb/icfKBYtmwYUktKjYm+Ct8PuyPBxK9H+1RyRhvDbLDjn5TlyQJ3doYK
         k/YcZkPZ7Gs/2sS1wsZ7/TWpfV6Hu09hnJuGzOTHnGdgPQeWrzzAcWTnd5QRjQuhfS
         U+uCYM13oGDXUzKg2vdbn9u4uyNNKkCtigEhfJo17UvBvo1cZMrmvAWhY5lRyhM6rS
         gG4PhhVN3o+HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mingo@redhat.com, shr@fb.com, joshi.k@samsung.com,
        usama.arif@bytedance.com, vasily.averin@linux.dev,
        asml.silence@gmail.com
Subject: [PATCH AUTOSEL 5.19 56/58] io_uring: fix io_uring_cqe_overflow trace format
Date:   Sun,  7 Aug 2022 21:31:14 -0400
Message-Id: <20220808013118.313965-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit 9b26e811e934eebda59362c9a03d082852552574 ]

Make the trace format consistent with io_uring_complete for cflags

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220630091231.1456789-12-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index aa2f951b07cd..6a12eef3ffb7 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -622,7 +622,7 @@ TRACE_EVENT(io_uring_cqe_overflow,
 		__entry->ocqe		= ocqe;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, res %d, flags %x, "
+	TP_printk("ring %p, user_data 0x%llx, res %d, cflags 0x%x, "
 		  "overflow_cqe %p",
 		  __entry->ctx, __entry->user_data, __entry->res,
 		  __entry->cflags, __entry->ocqe)
-- 
2.35.1

