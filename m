Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84F76086BB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiJVHww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiJVHv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F362C2AF3;
        Sat, 22 Oct 2022 00:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D7460B6B;
        Sat, 22 Oct 2022 07:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DE4C433D6;
        Sat, 22 Oct 2022 07:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424622;
        bh=vvroSdVnhpOzWpAlb2Ota3DJevOUQESG8b8NQmA2ZKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzoUd26cmmDtzdt4T7fljJZ9Axaag8op/CxXm4TLV3rrkG8JwKpa85FrFOxd6Llj+
         94vbKNXmPfGYiaJmsavaaeaIofQg07Jw3Al0hfareDFz02CwEOKFBUa0UiWWVn8Akx
         VhKOBYYTTqQGVoRXBszD1CASuhGrjiK9pyiyTQgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 197/717] NFSD: Protect against send buffer overflow in NFSv2 READDIR
Date:   Sat, 22 Oct 2022 09:21:16 +0200
Message-Id: <20221022072450.362303294@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 00b4492686e0497fdb924a9d4c8f6f99377e176c ]

Restore the previous limit on the @count argument to prevent a
buffer overflow attack.

Fixes: 53b1119a6e50 ("NFSD: Fix READDIR buffer overflow")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 16cde315f454..f65eba938a57 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -557,12 +557,11 @@ static void nfsd_init_dirlist_pages(struct svc_rqst *rqstp,
 	struct xdr_buf *buf = &resp->dirlist;
 	struct xdr_stream *xdr = &resp->xdr;
 
-	count = clamp(count, (u32)(XDR_UNIT * 2), svc_max_payload(rqstp));
-
 	memset(buf, 0, sizeof(*buf));
 
 	/* Reserve room for the NULL ptr & eof flag (-2 words) */
-	buf->buflen = count - XDR_UNIT * 2;
+	buf->buflen = clamp(count, (u32)(XDR_UNIT * 2), (u32)PAGE_SIZE);
+	buf->buflen -= XDR_UNIT * 2;
 	buf->pages = rqstp->rq_next_page;
 	rqstp->rq_next_page++;
 
-- 
2.35.1



