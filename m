Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6175D6BB043
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjCOMQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbjCOMQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EB1907BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E39B81C6F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCF6C433EF;
        Wed, 15 Mar 2023 12:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882588;
        bh=MPHwU2twBsP7J9EhB4NyzULXgNQLfH9s5zPlHFIKQM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v45NwPjyWX5PUf/764NGv24CJ4sxQeozRPTh4edE6OSIFAjsVhc886itIn2u/xSWk
         gkiF0m3A5keu7QMByEAbXG0HMNPhmV70aZ2VhaypTFcScOZzaWQ5tD4sdy+lbFmlJQ
         Popn1Do2IrnpO+4LkDb9gwB8gs+BVso0vI4pdVdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>, Lee Jones <lee@kernel.org>
Subject: [PATCH 4.19 35/39] tipc: improve function tipc_wait_for_cond()
Date:   Wed, 15 Mar 2023 13:12:49 +0100
Message-Id: <20230315115722.532326964@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -388,7 +388,7 @@ static int tipc_sk_sock_err(struct socke
 		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
 		if (rc_)						       \
 			break;						       \
-		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
+		add_wait_queue(sk_sleep(sk_), &wait_);                         \
 		release_sock(sk_);					       \
 		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
 		sched_annotate_sleep();				               \


