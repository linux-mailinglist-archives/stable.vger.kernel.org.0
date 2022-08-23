Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F90F59D3EC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242370AbiHWIQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242395AbiHWIOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84AD6CF64;
        Tue, 23 Aug 2022 01:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE7D8B81C23;
        Tue, 23 Aug 2022 08:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A63C433D6;
        Tue, 23 Aug 2022 08:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242192;
        bh=POaUdY32srVyb9CUvSK2Zuip7368nevwRVmjMokMMmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xtbl1vRz8vT/BxHJQv3MppLbKnH79JgHBaw1rD+ijQ/JBnbTzrEkxeQcN+984/LlZ
         EWXHZhM/F4iaVvP9uT9C2xFKGVcbb+MD9FMqG978utDn//hafxT9YPumHaunMeUEAS
         zKkm+chBGpMVYk4joCf/VRr2hoOoLfzlaoeQRGw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.19 074/365] SUNRPC: Fix xdr_encode_bool()
Date:   Tue, 23 Aug 2022 09:59:35 +0200
Message-Id: <20220823080121.269533997@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -419,8 +419,8 @@ static inline int xdr_stream_encode_item
  */
 static inline __be32 *xdr_encode_bool(__be32 *p, u32 n)
 {
-	*p = n ? xdr_one : xdr_zero;
-	return p++;
+	*p++ = n ? xdr_one : xdr_zero;
+	return p;
 }
 
 /**


