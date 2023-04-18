Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CB6E64DF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjDRMxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjDRMxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E86216DDF
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE3463463
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3166BC433EF;
        Tue, 18 Apr 2023 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822378;
        bh=F6q80nabvQNpLFsM3og/BNMlWlZ7hNIBRWTm36hddvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMMJWRV/wZNKOaZMkrK/otlZt/y7W75au7ad+viwb9YXesa45ParHD+8ya6KWnWWX
         y0ENj8rlInriFwejJgkMykM9X6Y8w3l6Neh6TN/pPOzJBNmIfQH3kjXkVa5IDctqZ3
         TYI4wg2k7fktoMiFsuV9o5zBgEugSauvn6VFPHkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 127/139] selftests: mptcp: userspace pm: uniform verify events
Date:   Tue, 18 Apr 2023 14:23:12 +0200
Message-Id: <20230418120318.625690997@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 711ae788cbbb82818531b55e32b09518ee09a11a upstream.

Simply adding a "sleep" before checking something is usually not a good
idea because the time that has been picked can not be enough or too
much. The best is to wait for events with a timeout.

In this selftest, 'sleep 0.5' is used more than 40 times. It is always
used before calling a 'verify_*' function except for this
verify_listener_events which has been added later.

At the end, using all these 'sleep 0.5' seems to work: the slow CIs
don't complain so far. Also because it doesn't take too much time, we
can just add two more 'sleep 0.5' to uniform what is done before calling
a 'verify_*' function. For the same reasons, we can also delay a bigger
refactoring to replace all these 'sleep 0.5' by functions waiting for
events instead of waiting for a fix time and hope for the best.

Fixes: 6c73008aa301 ("selftests: mptcp: listener test for userspace PM")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -884,6 +884,7 @@ test_listener()
 		$client4_port > /dev/null 2>&1 &
 	local listener_pid=$!
 
+	sleep 0.5
 	verify_listener_events $client_evts $LISTENER_CREATED $AF_INET 10.0.2.2 $client4_port
 
 	# ADD_ADDR from client to server machine reusing the subflow port
@@ -899,6 +900,7 @@ test_listener()
 	# Delete the listener from the client ns, if one was created
 	kill_wait $listener_pid
 
+	sleep 0.5
 	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port
 }
 


