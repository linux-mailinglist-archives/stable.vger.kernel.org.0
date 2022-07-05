Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F26566D2D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiGEMV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiGEMTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EE718E2B;
        Tue,  5 Jul 2022 05:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377FFB817D3;
        Tue,  5 Jul 2022 12:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748FFC341C7;
        Tue,  5 Jul 2022 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023332;
        bh=bQxN3bh++1R1mBIbbNcGTPNamM2kdxz0RwMIs1cqQhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXKcYJwxadFGHp0JPou6AvR7SL4pc7Feqw9lTE8GlrVyJai9TPmaTMbOHuJHZgrp0
         7VfYjN67bzWh3V7meZ8oWQbndPztF9CRCWDT77SBNfwaEHIzyE6eOYNlMg/xB8qKJN
         JTQLVBzCwEkzuYN+F06zq2K/9PDt3HcutWnIssvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Fields <bfields@fieldses.org>,
        Zorro Lang <zlang@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 022/102] SUNRPC: Fix READ_PLUS crasher
Date:   Tue,  5 Jul 2022 13:57:48 +0200
Message-Id: <20220705115619.047664900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit a23dd544debcda4ee4a549ec7de59e85c3c8345c upstream.

Looks like there are still cases when "space_left - frag1bytes" can
legitimately exceed PAGE_SIZE. Ensure that xdr->end always remains
within the current encode buffer.

Reported-by: Bruce Fields <bfields@fieldses.org>
Reported-by: Zorro Lang <zlang@redhat.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216151
Fixes: 6c254bf3b637 ("SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -979,7 +979,7 @@ static __be32 *xdr_get_next_encode_buffe
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	if (space_left - nbytes >= PAGE_SIZE)
+	if (space_left - frag1bytes >= PAGE_SIZE)
 		xdr->end = (void *)p + PAGE_SIZE;
 	else
 		xdr->end = (void *)p + space_left - frag1bytes;


