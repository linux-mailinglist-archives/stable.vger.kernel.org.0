Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239024B214B
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbiBKJPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:15:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiBKJPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:15:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4042E102D
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7A15B828BB
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7F9C340E9;
        Fri, 11 Feb 2022 09:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644570947;
        bh=EPGPXnPgqc/qgRpX6kmuUn4gxzhOy2HuJxNdRmY40Yw=;
        h=Subject:To:Cc:From:Date:From;
        b=kD18icNfqYazjaNxAhAjEC7++P6gQj/cst5jKZN/wksFRsylbQR5aMEJvfoX0igss
         qmcy18kT7yL19gJuPHSWvQY8V8aXtTyhJyHFiQ0GfOlYamC7HD/pUfsq7gpKtXuooa
         Tad9WPMejMThFi4FL1W7FJC6VUkP5Q42KOb50iQw=
Subject: FAILED: patch "[PATCH] NFSD: Fix NFSv3 SETATTR/CREATE's handling of large file sizes" failed to apply to 5.10-stable tree
To:     chuck.lever@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:15:45 +0100
Message-ID: <164457094520260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a648fdeb7c0e17177a2280344d015dba3fbe3314 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 25 Jan 2022 15:59:57 -0500
Subject: [PATCH] NFSD: Fix NFSv3 SETATTR/CREATE's handling of large file sizes

iattr::ia_size is a loff_t, so these NFSv3 procedures must be
careful to deal with incoming client size values that are larger
than s64_max without corrupting the value.

Silently capping the value results in storing a different value
than the client passed in which is unexpected behavior, so remove
the min_t() check in decode_sattr3().

Note that RFC 1813 permits only the WRITE procedure to return
NFS3ERR_FBIG. We believe that NFSv3 reference implementations
also return NFS3ERR_FBIG when ia_size is too large.

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 7c45ba4db61b..2e47a07029f1 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -254,7 +254,7 @@ svcxdr_decode_sattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		if (xdr_stream_decode_u64(xdr, &newsize) < 0)
 			return false;
 		iap->ia_valid |= ATTR_SIZE;
-		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
+		iap->ia_size = newsize;
 	}
 	if (xdr_stream_decode_u32(xdr, &set_it) < 0)
 		return false;

