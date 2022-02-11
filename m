Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8344B2157
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348417AbiBKJQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:16:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348363AbiBKJQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:16:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07990102D
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98EEC61EB6
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8104DC340E9;
        Fri, 11 Feb 2022 09:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644570982;
        bh=f0ckFNH85dDWN3qwt2iW3PuByDbDjn9g4mCXPnHVDoI=;
        h=Subject:To:Cc:From:Date:From;
        b=rU/TQhGUKLwZrqmmvcq8GHAlLZ553VJR5xv54fiGVSlnZCqr2oilib4IczsnezhqP
         0sFVgEubMrjLs+L19m7BLvhXitxQyIgaFSo6+LvarfyKINV6cSOK760UkqbXxBGOiN
         8du64sUzHp6BrW/ogyM0GQBxCgD4gXr3T7AGbMGY=
Subject: FAILED: patch "[PATCH] NFSD: Fix ia_size underflow" failed to apply to 4.9-stable tree
To:     chuck.lever@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:16:07 +0100
Message-ID: <1644570967130180@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6faac3f58c7c4176b66f63def17a34232a17b0e Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Mon, 31 Jan 2022 13:01:53 -0500
Subject: [PATCH] NFSD: Fix ia_size underflow

iattr::ia_size is a loff_t, which is a signed 64-bit type. NFSv3 and
NFSv4 both define file size as an unsigned 64-bit type. Thus there
is a range of valid file size values an NFS client can send that is
already larger than Linux can handle.

Currently decode_fattr4() dumps a full u64 value into ia_size. If
that value happens to be larger than S64_MAX, then ia_size
underflows. I'm about to fix up the NFSv3 behavior as well, so let's
catch the underflow in the common code path: nfsd_setattr().

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 99c2b9dfbb10..0cccceb105e7 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -435,6 +435,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			.ia_size	= iap->ia_size,
 		};
 
+		host_err = -EFBIG;
+		if (iap->ia_size < 0)
+			goto out_unlock;
+
 		host_err = notify_change(&init_user_ns, dentry, &size_attr, NULL);
 		if (host_err)
 			goto out_unlock;

