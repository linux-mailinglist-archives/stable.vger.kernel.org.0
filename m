Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD85B8457
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiINJKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiINJKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:10:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C718397;
        Wed, 14 Sep 2022 02:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFA8ACE1101;
        Wed, 14 Sep 2022 09:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE0C43141;
        Wed, 14 Sep 2022 09:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146275;
        bh=Qho7i5LSrxIp5Wu+1pNW6aCTDbQKMxqN+D1HdVTWPS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mV6p4RSKHEozEh3KDPHQG22TgTOSqX/TxMlk7Ue+Knh/KGJg3TP4R2WOnRxi0cSQJ
         M8s7OZsc7vx0sKkouUjdcV0Iq2HgmBBF1GRhVYQp/iKSsO/gPo7wHUc1z7TWnovu+U
         RAklfMRVe2iObR//4tJhjEV/YKZEjTAGfgm1JG0oV2TXmd2pXBVS02fkSaNyX6m3A8
         t/IlWzOtth+H/kMACYaWE8jDxTZcW/xdyuQkf7EBAlwUH6LQE5scizuxAapQznFydZ
         riRYaEd0h5OUN/v72WP1fPFaMpTIjup/JIwKceSP9lDXE4wi5Zb/c4WFYDFvs/s4L/
         GUYb6M6gwNSsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jeffrey E Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/12] afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked
Date:   Wed, 14 Sep 2022 05:04:02 -0400
Message-Id: <20220914090407.471328-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090407.471328-1-sashal@kernel.org>
References: <20220914090407.471328-1-sashal@kernel.org>
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
index 5334f1bd2bca7..5171d6d990315 100644
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

