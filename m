Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7B230B7
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbfETJvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:51:23 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35469 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729847AbfETJvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 05:51:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 88EFF23A31;
        Mon, 20 May 2019 05:51:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 May 2019 05:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PS8evO
        0l53deOafiDMjwchQMigj/oxoyDFwpgSgVTyc=; b=KAGf9JcAfO4yqvMtjB0N1f
        i8cYBBQ26S5YhTk/GTKjbCFc/4sHCdK1a+ynilCglRm0AkQMU+BtEPjXq5le1j0b
        d6H81glL8PDBdXsXce+L1HwsHA8PsxJTrec2VqgsLSVCvcq75o7bDZT0DC3Wq4RI
        lVnASY6bjckd01LeY6jDh3wG4KtJ7qVyl4mRs42fApWk0n+cpQvb24h6Xkqpt59g
        ChODWSUKTpA0Icx0u+D6Gxld1e8WZqmftVYYCy1DXFBOrsikKIIH4KazKDZALKkF
        3Xyr7DTV4KccCWRRWejZg88Ff8aIw9fek13uQf4+Cyrr8yn6y452usFlNtwUrmyA
        ==
X-ME-Sender: <xms:mnjiXH8GzgBtGEkRFJqo8liypaIuilA7twqzXoPt_vor-1t8rl0c-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:mnjiXPfHCqrf66WM3QhgemAmpDN-nr3LU6Cn2NUZaJUWOxlqR6t5jA>
    <xmx:mnjiXIlDlDLwZZ-eIErkmNx3W5dsYqTMADOJgUc6dngYlsgl_1j5Hw>
    <xmx:mnjiXPJsQQN3ezbprIafKTNSnApXnngNpE36uNeSjU45Bu1L-ttSaA>
    <xmx:mnjiXKBu9WLqtlLSzWm7-B3CrfYypqRkAEqtwNorXII22DFno9wIFg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CA0E10379;
        Mon, 20 May 2019 05:51:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix data corruption caused by overlapping unaligned and" failed to apply to 4.4-stable tree
To:     lczerner@redhat.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 11:51:20 +0200
Message-ID: <155834588016549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57a0da28ced8707cb9f79f071a016b9d005caf5a Mon Sep 17 00:00:00 2001
From: Lukas Czerner <lczerner@redhat.com>
Date: Fri, 10 May 2019 21:45:33 -0400
Subject: [PATCH] ext4: fix data corruption caused by overlapping unaligned and
 aligned IO

Unaligned AIO must be serialized because the zeroing of partial blocks
of unaligned AIO can result in data corruption in case it's overlapping
another in flight IO.

Currently we wait for all unwritten extents before we submit unaligned
AIO which protects data in case of unaligned AIO is following overlapping
IO. However if a unaligned AIO is followed by overlapping aligned AIO we
can still end up corrupting data.

To fix this, we must make sure that the unaligned AIO is the only IO in
flight by waiting for unwritten extents conversion not just before the
IO submission, but right after it as well.

This problem can be reproduced by xfstest generic/538

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 98ec11f69cd4..2c5baa5e8291 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -264,6 +264,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	ret = __generic_file_write_iter(iocb, from);
+	/*
+	 * Unaligned direct AIO must be the only IO in flight. Otherwise
+	 * overlapping aligned IO after unaligned might result in data
+	 * corruption.
+	 */
+	if (ret == -EIOCBQUEUED && unaligned_aio)
+		ext4_unwritten_wait(inode);
 	inode_unlock(inode);
 
 	if (ret > 0)

