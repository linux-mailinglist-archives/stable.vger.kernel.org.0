Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A998A20AAB2
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 05:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgFZD3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 23:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZD3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 23:29:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C48420899;
        Fri, 26 Jun 2020 03:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593142180;
        bh=c9dYFhRT3mVmYx9tNYP7+Af3F0aNcfc8rcYBPx0okFg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hrlipQaRLn+SbSE5HcYLV0f7oOb1NHIjIRQjZ6oINMCGQWo43nPKyR9FOu13gJGa/
         HRiBn7zPJwxuvMyA5DyNP5oGgHHKTWJrn+HsuYA//OP5xEYJmnVTaxIMPWvTnfFXX/
         eCRCVU9cKy4wusC2Cq16xJ+aE/TgJrlsdLOeuZLA=
Date:   Thu, 25 Jun 2020 20:29:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/32] ocfs2: fix value of OCFS2_INVALID_SLOT
Message-ID: <20200626032940.e1Dlt7Co6%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix value of OCFS2_INVALID_SLOT

In the ocfs2 disk layout, slot number is 16 bits, but in ocfs2
implementation, slot number is 32 bits.  Usually this will not cause any
issue, because slot number is converted from u16 to u32, but
OCFS2_INVALID_SLOT was defined as -1, when an invalid slot number from
disk was obtained, its value was (u16)-1, and it was converted to u32. 
Then the following checking in get_local_system_inode will be always
skipped:

 static struct inode **get_local_system_inode(struct ocfs2_super *osb,
                                               int type,
                                               u32 slot)
 {
 	BUG_ON(slot == OCFS2_INVALID_SLOT);
	...
 }

Link: http://lkml.kernel.org/r/20200616183829.87211-5-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-fix-value-of-ocfs2_invalid_slot
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -290,7 +290,7 @@
 #define OCFS2_MAX_SLOTS			255
 
 /* Slot map indicator for an empty slot */
-#define OCFS2_INVALID_SLOT		-1
+#define OCFS2_INVALID_SLOT		((u16)-1)
 
 #define OCFS2_VOL_UUID_LEN		16
 #define OCFS2_MAX_VOL_LABEL_LEN		64
_
