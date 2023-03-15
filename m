Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC46BB018
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCOMP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCOMPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFF572B06
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCAAD61D48
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C86C4339B;
        Wed, 15 Mar 2023 12:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882509;
        bh=QP5IPoiSN21efxzQJiAEOxYEhmg9Fgidb+lXclVjcfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiK8xjGbIpxtwoSX0wSXdA59tGrRAJtWpvUgnHTmQhPfPBH3cYNhTaNujqY+75Hwn
         ggdzMJM2OFnQwiBSmFBXiUwTnVHsqqcbZq5t+tDbd9X+DBW2+mSBS4HevVjmgzKBIU
         wXXAfu85jmMDXFfHvwkkDFq0ToPxYKLCKSFoHlfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>, Lee Jones <lee@kernel.org>
Subject: [PATCH 4.14 19/21] tipc: improve function tipc_wait_for_cond()
Date:   Wed, 15 Mar 2023 13:12:42 +0100
Message-Id: <20230315115719.550974154@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

commit 223b7329ec6a0dae1b7f7db7b770e93f4a069ef9 upstream.

Commit 844cf763fba6 ("tipc: make macro tipc_wait_for_cond() smp safe")
replaced finish_wait() with remove_wait_queue() but still used
prepare_to_wait(). This causes unnecessary conditional
checking  before adding to wait queue in prepare_to_wait().

This commit replaces prepare_to_wait() with add_wait_queue()
as the pair function with remove_wait_queue().

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -373,7 +373,7 @@ static int tipc_sk_sock_err(struct socke
 		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
 		if (rc_)						       \
 			break;						       \
-		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
+		add_wait_queue(sk_sleep(sk_), &wait_);                         \
 		release_sock(sk_);					       \
 		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
 		sched_annotate_sleep();				               \


