Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7539D6584CB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiL1RCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbiL1RCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:02:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AA21F2D3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:56:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 222A36157A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35568C433F0;
        Wed, 28 Dec 2022 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246579;
        bh=00NmHKHRLwzQLMEdhQ7IO6s1VJuatijNqi22o4B2TiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of38uMQYJtYvrfjOUZC5ubexpD2aGL7Udw851XJnjpq2lSklzd8uJqrsvmz6xpngd
         FMEyGeOzALYpufMg8hJjHWbYINIgIPXYMgBFvLLISvKFY5GWbpVnFb78lctTImdbou
         SrbqkVacdHmM6bZsPmmfhacuAoaRmZzHKI0LMhno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1088/1146] afs: Fix lost servers_outstanding count
Date:   Wed, 28 Dec 2022 15:43:47 +0100
Message-Id: <20221228144359.742298802@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 36f82c93ee0bd88f1c95a52537906b8178b537f1 ]

The afs_fs_probe_dispatcher() work function is passed a count on
net->servers_outstanding when it is scheduled (which may come via its
timer).  This is passed back to the work_item, passed to the timer or
dropped at the end of the dispatcher function.

But, at the top of the dispatcher function, there are two checks which
skip the rest of the function: if the network namespace is being destroyed
or if there are no fileservers to probe.  These two return paths, however,
do not drop the count passed to the dispatcher, and so, sometimes, the
destruction of a network namespace, such as induced by rmmod of the kafs
module, may get stuck in afs_purge_servers(), waiting for
net->servers_outstanding to become zero.

Fix this by adding the missing decrements in afs_fs_probe_dispatcher().

Fixes: f6cbb368bcb0 ("afs: Actively poll fileservers to maintain NAT or firewall openings")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/167164544917.2072364.3759519569649459359.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_probe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index 3ac5fcf98d0d..daaf3810cc92 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -366,12 +366,15 @@ void afs_fs_probe_dispatcher(struct work_struct *work)
 	unsigned long nowj, timer_at, poll_at;
 	bool first_pass = true, set_timer = false;
 
-	if (!net->live)
+	if (!net->live) {
+		afs_dec_servers_outstanding(net);
 		return;
+	}
 
 	_enter("");
 
 	if (list_empty(&net->fs_probe_fast) && list_empty(&net->fs_probe_slow)) {
+		afs_dec_servers_outstanding(net);
 		_leave(" [none]");
 		return;
 	}
-- 
2.35.1



