Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C205B83CD
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiINJEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiINJC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FC175FCE;
        Wed, 14 Sep 2022 02:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A3F061993;
        Wed, 14 Sep 2022 09:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C12C433D6;
        Wed, 14 Sep 2022 09:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146122;
        bh=h6V+HVeJGUJ6+d4I/CJ7icZu32wjW17j9ROvOYevtNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2CmBf5RrH7gVA1CQBTxHIZ/3g5+5mt2fK+NfclDqH5ZfubUelI7QrMDOyR19tQt0
         xKbkZM5S2ntJ0Y9NbSegSCIGiNOuuvkZ8HbTLrOiAss5JTmMlwCOpdRrlFViFaZoRR
         9FZoJ5gxnAZsZgdf2HkFQmuDWKPQoahoxI/LR5mooXksoLKPmoTRx7xlA1PodMjp4v
         r1BN/WDUnYQCB1GzMFons2Fb6gmjRZCzYyWdYpBb1UA631aRcyOuC7qrZu4QzooSVn
         RtTVM1Rfx0xYphpPe/uBKzctWrqtHPczjeuVYqk1pdgktr6qUb7rTJ8VwYyer16bdb
         QFJCM37gA0OFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jeffrey E Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 17/22] afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked
Date:   Wed, 14 Sep 2022 05:00:58 -0400
Message-Id: <20220914090103.470630-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0066f1b0e27556381402db3ff31f85d2a2265858 ]

When trying to get a file lock on an AFS file, the server may return
UAEAGAIN to indicate that the lock is already held.  This is currently
translated by the default path to -EREMOTEIO.

Translate it instead to -EAGAIN so that we know we can retry it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey E Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/166075761334.3533338.2591992675160918098.stgit@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/misc.c b/fs/afs/misc.c
index 933e67fcdab1a..805328ca54284 100644
--- a/fs/afs/misc.c
+++ b/fs/afs/misc.c
@@ -69,6 +69,7 @@ int afs_abort_to_error(u32 abort_code)
 		/* Unified AFS error table */
 	case UAEPERM:			return -EPERM;
 	case UAENOENT:			return -ENOENT;
+	case UAEAGAIN:			return -EAGAIN;
 	case UAEACCES:			return -EACCES;
 	case UAEBUSY:			return -EBUSY;
 	case UAEEXIST:			return -EEXIST;
-- 
2.35.1

