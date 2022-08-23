Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6D59D944
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbiHWJzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345929AbiHWJyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB97B9F77B;
        Tue, 23 Aug 2022 01:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 622E3B81BF8;
        Tue, 23 Aug 2022 08:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E00C433C1;
        Tue, 23 Aug 2022 08:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244386;
        bh=d/nMLC3Lz+jLZL1pYaR6VR52kEJoAe2FcyZI315sBwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0KubDfnsEdgN1njRQad92H3TEYqQpe+0hnNlyaZg+lEx8yp2ryifjNTz3gebDNa5
         iRb6SD76tTbrLHc6r9uo/Uhlio/uhldNMTXJtSx66u0Qwi5NJ84M32fgrYPqrIZsDl
         3T/I2B27ryG08chxHaPS2SgT3yPwl6rN2Q5N6vKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 054/244] SUNRPC: Fix xdr_encode_bool()
Date:   Tue, 23 Aug 2022 10:23:33 +0200
Message-Id: <20220823080100.868709019@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Chuck Lever <chuck.lever@oracle.com>

commit c770f31d8f580ed4b965c64f924ec1cc50e41734 upstream.

I discovered that xdr_encode_bool() was returning the same address
that was passed in the @p parameter. The documenting comment states
that the intent is to return the address of the next buffer
location, just like the other "xdr_encode_*" helpers.

The result was the encoded results of NFSv3 PATHCONF operations were
not formed correctly.

Fixes: ded04a587f6c ("NFSD: Update the NFSv3 PATHCONF3res encoder to use struct xdr_stream")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/xdr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -405,8 +405,8 @@ static inline int xdr_stream_encode_item
  */
 static inline __be32 *xdr_encode_bool(__be32 *p, u32 n)
 {
-	*p = n ? xdr_one : xdr_zero;
-	return p++;
+	*p++ = n ? xdr_one : xdr_zero;
+	return p;
 }
 
 /**


