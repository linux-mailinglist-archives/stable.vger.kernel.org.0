Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58364603DD0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiJSJGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiJSJFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD56559D;
        Wed, 19 Oct 2022 01:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3ACF61830;
        Wed, 19 Oct 2022 08:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338BC433D7;
        Wed, 19 Oct 2022 08:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169294;
        bh=qVYDYelSXhkHfR0AgcNhAsoBtqPipV6eiUkZlAcvI5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHx2YRrhaJ0sA/pz5Myz4yV257qDFjZ8K23rnDucjk6zIogdyouVF1406vFfJzh9L
         8nJVdwMskHQ682ymeAj+luTBXmoUi0tH0YRk2T5C7YkRmATrCD54JhjIhdaZ8/nGAs
         UOj33h7gZ/ZbdS+j7++MwOLF+UK1rvK9T3JQ2ypo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 223/862] SUNRPC: Fix svcxdr_init_encodes buflen calculation
Date:   Wed, 19 Oct 2022 10:25:10 +0200
Message-Id: <20221019083259.890877538@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 ]

Commit 2825a7f90753 ("nfsd4: allow encoding across page boundaries")
added an explicit computation of the remaining length in the rq_res
XDR buffer.

The computation appears to suffer from an "off-by-one" bug. Because
buflen is too large by one page, XDR encoding can run off the end of
the send buffer by eventually trying to use the struct page address
in rq_page_end, which always contains NULL.

Fixes: bddfdbcddbe2 ("NFSD: Extract the svcxdr_init_encode() helper")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 5a830b66f059..0ca8a8ffb47e 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -587,7 +587,7 @@ static inline void svcxdr_init_encode(struct svc_rqst *rqstp)
 	xdr->end = resv->iov_base + PAGE_SIZE - rqstp->rq_auth_slack;
 	buf->len = resv->iov_len;
 	xdr->page_ptr = buf->pages - 1;
-	buf->buflen = PAGE_SIZE * (1 + rqstp->rq_page_end - buf->pages);
+	buf->buflen = PAGE_SIZE * (rqstp->rq_page_end - buf->pages);
 	buf->buflen -= rqstp->rq_auth_slack;
 	xdr->rqst = NULL;
 }
-- 
2.35.1



