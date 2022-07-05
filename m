Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC43566AFB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiGEMDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiGEMCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF98E17E28;
        Tue,  5 Jul 2022 05:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C43161840;
        Tue,  5 Jul 2022 12:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CACC341C7;
        Tue,  5 Jul 2022 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022574;
        bh=edsKe0FVOvsRAYwbS5XjA2Hdnp3PFY86vrBZUlfMG/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVTW77NAgPUkGmDxTMV2wm1/CuwG4uqXziTk2npJ9Q0sQV0dGr3BQGnlKa2bKx9qG
         tvdnUJakLlsF4avu0hjXhvNw1EjtvR6tVdE5UDJ1RMS7GwzykTkG60RHCAnDjxUydR
         t8U8oJ0AvAv1EVqFDKL0ROKvWz7gTAnoaucIid9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Fields <bfields@fieldses.org>,
        Zorro Lang <zlang@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 05/33] SUNRPC: Fix READ_PLUS crasher
Date:   Tue,  5 Jul 2022 13:57:57 +0200
Message-Id: <20220705115606.868578059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
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
@@ -544,7 +544,7 @@ static __be32 *xdr_get_next_encode_buffe
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	if (space_left - nbytes >= PAGE_SIZE)
+	if (space_left - frag1bytes >= PAGE_SIZE)
 		xdr->end = (void *)p + PAGE_SIZE;
 	else
 		xdr->end = (void *)p + space_left - frag1bytes;


