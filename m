Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C6C1A7F3A
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbgDNOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:09:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51273 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389175AbgDNOJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:09:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0022C5C027E;
        Tue, 14 Apr 2020 10:09:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XZIPC7
        58dMGnrEOVmcpsR/kH/TGXEMxNqdQULBPcml8=; b=Oj4oRvR8dNc7DpfkWwmbnU
        lBHZqZBk4+E8N4ow1F5nBdG67uIrZ1d9r8GA+SXJgRvPO4M9hI9ahFP16Ey3J36+
        a+rzH7NLSxstToipawcu89qcCAz1j5GGyMct6/570pC5LM+o8aou0dp/tWQpj/gD
        ze5THa5DlHC3M+Jh07k57XX0oCSEOAaODlgeYT339SlkakU5P5GijqsQf7eEFsbx
        2dVH+wQyvMO9BTlqdk7cqQf3ZVC3mnSeaiDwl3k63eFiI16O1ZU+eER6hscfj8T0
        6my4gUn/A2g9shM4CpzwfAVZft9S8m6P7RCIxLXn1BsmcPSNF0uXCx5v+RNkqzNA
        ==
X-ME-Sender: <xms:JMSVXq05dw09jp4V1b0AMA6AM3z3KC5JKOe8HvHXaGY_f-kuapHGUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JMSVXp78ogbQ91XKsPUC5LYKOGtwn8kmh1nSHzUPNy1_VKj9vDFpbA>
    <xmx:JMSVXlJhBYznEN58tCAzvM2ed6MaaRNKONJtcuyC7cwJ8n1I70uF4w>
    <xmx:JMSVXr8cpQvIOMDMdl2u9_9PBmM9R65uT2mxEK2Ek5hpZlNodT3D7g>
    <xmx:JMSVXlKNGNgJu4Yia_evqJIOf3OqMWdG2wtz4OU_pH_GZxUBZ1rd7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CF58306005E;
        Tue, 14 Apr 2020 10:09:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] CIFS: check new file size when extending file by fallocate" failed to apply to 5.5-stable tree
To:     jencce.kernel@gmail.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:09:38 +0200
Message-ID: <158687337815523@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef4a632ccc1c7d3fb71a5baae85b79af08b7f94b Mon Sep 17 00:00:00 2001
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Wed, 18 Mar 2020 20:43:38 +0800
Subject: [PATCH] CIFS: check new file size when extending file by fallocate

xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
After fallocate mode 0 extending enabled, we can hit this failure.
Fix this by check the new file size with vfs helper, return
error if file size is larger then RLIMIT_FSIZE(ulimit -f).

This patch has been tested by LTP/xfstests aginst samba and
Windows server.

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b0759c8aa6f5..9c9258fc8756 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3255,6 +3255,10 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	 * Extending the file
 	 */
 	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		rc = inode_newsize_ok(inode, off + len);
+		if (rc)
+			goto out;
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 

