Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1E55B8434
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiINJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiINJHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:07:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC01792F8;
        Wed, 14 Sep 2022 02:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D24E0B81719;
        Wed, 14 Sep 2022 09:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D512EC4347C;
        Wed, 14 Sep 2022 09:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146233;
        bh=XRmvrvc4yUEskb2K/HcOIPUaK0m9MB3XjJvnZrSMP58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2kp2PzF/llK130BdvgixwpnkGULMw/V4eMtrgJdvdky76hWLDT+3XR9U3RIw1z+d
         1GSKAeNHYSRhbiyK/oWqhlLNwglA5CR1scou/7QyqHTrGi+OwdM5tNZGwoHJWD3MzA
         lAhz6f2mVUHGMXZdgarhscREsFgd/hmnBfzVmeB/+OWKKs3XggPbGVz8ZbwNIdot7t
         9g+X90XCOCUsql0faYjR1L1F+f1X81ePVsjC1jF/P7UDxaw/mbPlXNiFHcvhnxNaQE
         YjkoSriKzHLvWCfgIizY01E57kzDz034BiIGnKI0rOy+lB1t66HsujKakpJEYDR24s
         +ANuxu+X27wCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Jeffrey E Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 10/13] afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked
Date:   Wed, 14 Sep 2022 05:03:12 -0400
Message-Id: <20220914090317.471116-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090317.471116-1-sashal@kernel.org>
References: <20220914090317.471116-1-sashal@kernel.org>
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
index 1d1a8debe4723..f1dc2162900a4 100644
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

