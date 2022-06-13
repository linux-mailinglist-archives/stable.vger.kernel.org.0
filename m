Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76D0549383
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353419AbiFMMQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357667AbiFMMOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FD5401E;
        Mon, 13 Jun 2022 04:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8DD6145E;
        Mon, 13 Jun 2022 11:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE55C34114;
        Mon, 13 Jun 2022 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118090;
        bh=ITf6Cdy4CyDUHGrkyJUZk8fAMGlaFWg6Kp0pTCFjMW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu3L48D8WmKjihJOQSyU7okllOdTLqmVsCR/YB7Y4yzJ8MYAFva8l27ooIhPpSvlP
         kkIWgdBqSD6RVHXvu5lzgPMIFLBtDJfZWvo5N+nia6hkGFT5kpguzst+m7NHgwYnOA
         5nT8Fm+vc+2X89HBMgfhF7oSF3imRjfvjmoSFZ1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/287] SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()
Date:   Mon, 13 Jun 2022 12:11:04 +0200
Message-Id: <20220613094931.293675858@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6c254bf3b637dd4ef4f78eb78c7447419c0161d7 ]

I found that NFSD's new NFSv3 READDIRPLUS XDR encoder was screwing up
right at the end of the page array. xdr_get_next_encode_buffer() does
not compute the value of xdr->end correctly:

 * The check to see if we're on the final available page in xdr->buf
   needs to account for the space consumed by @nbytes.

 * The new xdr->end value needs to account for the portion of @nbytes
   that is to be encoded into the previous buffer.

Fixes: 2825a7f90753 ("nfsd4: allow encoding across page boundaries")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xdr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 540e340e2565..34596d0e4bde 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -544,7 +544,11 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	xdr->end = (void *)p + min_t(int, space_left, PAGE_SIZE);
+	if (space_left - nbytes >= PAGE_SIZE)
+		xdr->end = (void *)p + PAGE_SIZE;
+	else
+		xdr->end = (void *)p + space_left - frag1bytes;
+
 	xdr->buf->page_len += frag2bytes;
 	xdr->buf->len += nbytes;
 	return p;
-- 
2.35.1



