Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123E15EA044
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiIZKfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiIZKen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:34:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CDC4A121;
        Mon, 26 Sep 2022 03:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 756CCB80682;
        Mon, 26 Sep 2022 10:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95EDC4314C;
        Mon, 26 Sep 2022 10:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187674;
        bh=u2rO/ercHtrvsYkINPsSjr86xEcZCu/JUchqEDLRKLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdszsFlqTW7HZ+OS1DwkrzEAJEI0n9NOZr9qM0clkdJpq1CMJOFqyVgCEwxQWDep+
         ADM2mYaz57l+2UhZXno528DFyZ7U+Em1mwnPmddN5x49lYHc0boMpiPiG+zOwyuHPj
         LbMVe3Zl+ROmpk+Mj9MTlkJsbQMNt7DpODVjNAlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeffrey E Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/120] afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked
Date:   Mon, 26 Sep 2022 12:10:56 +0200
Message-Id: <20220926100751.471507380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 5334f1bd2bca..5171d6d99031 100644
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



