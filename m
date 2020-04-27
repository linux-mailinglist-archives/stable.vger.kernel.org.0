Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47261BAD3A
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 20:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgD0Sv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 14:51:26 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36559 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgD0Sv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 14:51:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9703919414C3;
        Mon, 27 Apr 2020 14:51:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 14:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ce6Kpk
        rS9loatmvMwSyTWTswxKsIBw1SWxMpYNkgBEA=; b=nimOC0Wp/KflonzX6jSu3F
        nHDxpro6g/Fpdz4jrvi6uJvN9gTkMsRMk01HxNIFVy0i6XGiIdsSi47j4xIJk/Lm
        wt7jaE3kBlKHEIEyQ3zyIgWeTa6f0fhNvz1VhkjOmXyvv3qs8o4gr51r/hftUwwX
        AcRAoYgZWoO9tSarKvUJO8DGZ3/nB44HkGpMRifbfBPCz+jUJPsdNGmeRW3Oh6Aw
        kKAXcrtbMHZKKKqdu2uUJMQUk72JRpCJu+E1aU6M7ZIRxMVqDiKKUxauAsB8L++Y
        +m+xPAEYUhbjCgWyC7AaSSlYnVYXyuZJtJJD2vk0Kl4a5LnnW+l21gPJeDVy5xoQ
        ==
X-ME-Sender: <xms:rSmnXsGsj8pobBnkRE_NmQKsRf8iBGUX5VqhpLuRR9ArzF009fBnUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rSmnXgKGhsO-0wbFe5vLbYHq-jU94Em_P4NXtl40mDkl7iVVPczhEg>
    <xmx:rSmnXkanrDTvjDkHULuYv_8IIl84LpVK2CGpJthPx66i1-SWOB5vHw>
    <xmx:rSmnXtrUO36pV7dG7qzkaA8kRuJtkRUkfE2NBnpURLNnavw3Z-mSUg>
    <xmx:rSmnXv9Efp7gbygTxjaABR4gh6UDGkx8JgkkZzx5L1JtSeakQaKLuQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5CDD3280064;
        Mon, 27 Apr 2020 14:51:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs: fix uninitialised lease_key in open_shroot()" failed to apply to 4.19-stable tree
To:     pc@cjr.nz, aaptel@suse.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 20:51:22 +0200
Message-ID: <158801348221944@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fe0781f29dd8ab618999e6bda33c782ebbdb109 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Mon, 20 Apr 2020 23:44:24 -0300
Subject: [PATCH] cifs: fix uninitialised lease_key in open_shroot()

SMB2_open_init() expects a pre-initialised lease_key when opening a
file with a lease, so set pfid->lease_key prior to calling it in
open_shroot().

This issue was observed when performing some DFS failover tests and
the lease key was never randomly generated.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b36c46f48705..f829f4165d38 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -687,6 +687,11 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
+	if (!server->ops->new_lease_key)
+		return -EIO;
+
+	server->ops->new_lease_key(pfid);
+
 	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));

