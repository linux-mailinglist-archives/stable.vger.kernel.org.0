Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A34D82B3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbiCNMG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240649AbiCNMG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:06:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B701263E;
        Mon, 14 Mar 2022 05:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 906B1B80DEB;
        Mon, 14 Mar 2022 12:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3692C340E9;
        Mon, 14 Mar 2022 12:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259378;
        bh=biVQO26JNhnpkhW6bbPtwyeL1122P5bPQiLIBuM1CHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNgoaeBjT9uvF63gEMUXmeIq7Pt65X8a1ZOARaELOcd5lC/k3H0lmCnog2BOY64Ik
         WuvjLbz+o2oShL77Q9CADpgYEUmJ8xKbTyVzDuujN97MUfVb2MNby2JHcey1plM/pp
         Oda2qqgrobIt61YYlt+rqciNNJyj73W1jf9cyALg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 65/71] watch_queue: Make comment about setting ->defunct more accurate
Date:   Mon, 14 Mar 2022 12:53:58 +0100
Message-Id: <20220314112739.758174190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 4edc0760412b0c4ecefc7e02cb855b310b122825 upstream.

watch_queue_clear() has a comment stating that setting ->defunct to true
preventing new additions as well as preventing notifications.  Whilst
the latter is true, the first bit is superfluous since at the time this
function is called, the pipe cannot be accessed to add new event
sources.

Remove the "new additions" bit from the comment.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -569,7 +569,7 @@ void watch_queue_clear(struct watch_queu
 	rcu_read_lock();
 	spin_lock_bh(&wqueue->lock);
 
-	/* Prevent new additions and prevent notifications from happening */
+	/* Prevent new notifications from being stored. */
 	wqueue->defunct = true;
 
 	while (!hlist_empty(&wqueue->watches)) {


