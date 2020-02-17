Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5237A161B38
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgBQTHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:07:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59737 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728054AbgBQTHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:07:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DFD2521F55;
        Mon, 17 Feb 2020 14:07:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:07:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=X3k/sr
        uUukMZqkFcA9EoMSTbz5Jr/oAG/amRA9tRg8Y=; b=JHZEruccw6OHcqQBbIhK62
        y+8pYanGSzaWxwoC3BIX0R4qiR0GinK285X4EPTaf2xL8bSF10oknS63YejYa9gd
        lte3MK5ixgw4FTZUWxJphKBxQ3gx05rsOCAWnCBY3VqNUNsjgsEun0RkNVjmzzws
        GA1vvO02ss35fz/QSNA+Vnd1HgjAnmbyZ2HisGExVtwmFkz7YsyzIe1qzkhLwl3n
        FwpMrzwY2ftFnj5vKyy2KdY3ybhSgdekwsrlYMR51mFnNxBnsMiufE9cs+MgfBzn
        Qp6ot/MTRxiRBWeWtMh43avD8Cd7o/gGhPWe1T9vXAba3XEN8i0lstKoHEUpPYeA
        ==
X-ME-Sender: <xms:geRKXq7xhWPWgORK-k2uB5Gtc6x4qQKd4w5hJV37kQ99xHcCreSuPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:geRKXiLzeXEXl9XJ13XMYfeLAnxRndAmxU4CRYCZ_V8EVj3hhFitsw>
    <xmx:geRKXmmSRGTZPF8CpCFWXaPDBE-hxFrBmNwsp5FGLPjMEOpByl9Owg>
    <xmx:geRKXp_3Zl7BWO3GL6_1-As9cG9NzUQLggBweu2yqdwlb9NdebKEAw>
    <xmx:geRKXtBhi_Sw_qNRvmZdfdFZDG38jW-95NxtsIvXHm6zCFfvClAbSg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35C8E3060EF2;
        Mon, 17 Feb 2020 14:07:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: simplify checking quota limits in ext4_statfs()" failed to apply to 5.4-stable tree
To:     jack@suse.cz, scan-admin@coverity.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:07:40 +0100
Message-ID: <158196646010095@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46d36880d1c6f9b9a0cbaf90235355ea1f4cab96 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 30 Jan 2020 12:11:48 +0100
Subject: [PATCH] ext4: simplify checking quota limits in ext4_statfs()

Coverity reports that conditions checking quota limits in ext4_statfs()
contain dead code. Indeed it is right and current conditions can be
simplified.

Link: https://lore.kernel.org/r/20200130111148.10766-1-jack@suse.cz
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 88b213bd32bc..f23367a779e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5585,10 +5585,7 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	limit = dquot->dq_dqb.dqb_bsoftlimit;
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
@@ -5603,10 +5600,7 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_isoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_isoftlimit;
+	limit = dquot->dq_dqb.dqb_isoftlimit;
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
 		limit = dquot->dq_dqb.dqb_ihardlimit;

