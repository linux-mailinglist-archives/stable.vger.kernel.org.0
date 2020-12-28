Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C712E65B7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389001AbgL1NZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388995AbgL1NZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8BD22A84;
        Mon, 28 Dec 2020 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161906;
        bh=RoysQs+gxXGp63xNUERVOgDtnxepKhU9f5tOZDw9G7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+9/DXTCbpnI+ZKHXtLYN/pEJPSH59xk8MZcRxcF63PuojAxJvfYyRHvEwmsOcFl0
         kQQjgHaFi/lkdeG1zkq9oHnhe2rYnk0arY44Jj9+MfshEIy5B54VfR1v4iAt9ETFxu
         oB0M17y6HhpMlTDrMyJrAd0n/gsbgD3MCU6znWwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 092/346] quota: Sanity-check quota file headers on load
Date:   Mon, 28 Dec 2020 13:46:51 +0100
Message-Id: <20201228124924.248082355@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 11c514a99bb960941535134f0587102855e8ddee upstream.

Perform basic sanity checks of quota headers to avoid kernel crashes on
corrupted quota files.

CC: stable@vger.kernel.org
Reported-by: syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/quota_v2.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -158,6 +158,25 @@ static int v2_read_file_info(struct supe
 		qinfo->dqi_entry_size = sizeof(struct v2r1_disk_dqblk);
 		qinfo->dqi_ops = &v2r1_qtree_ops;
 	}
+	ret = -EUCLEAN;
+	/* Some sanity checks of the read headers... */
+	if ((loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits >
+	    i_size_read(sb_dqopt(sb)->files[type])) {
+		quota_error(sb, "Number of blocks too big for quota file size (%llu > %llu).",
+		    (loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits,
+		    i_size_read(sb_dqopt(sb)->files[type]));
+		goto out;
+	}
+	if (qinfo->dqi_free_blk >= qinfo->dqi_blocks) {
+		quota_error(sb, "Free block number too big (%u >= %u).",
+			    qinfo->dqi_free_blk, qinfo->dqi_blocks);
+		goto out;
+	}
+	if (qinfo->dqi_free_entry >= qinfo->dqi_blocks) {
+		quota_error(sb, "Block with free entry too big (%u >= %u).",
+			    qinfo->dqi_free_entry, qinfo->dqi_blocks);
+		goto out;
+	}
 	ret = 0;
 out:
 	up_read(&dqopt->dqio_sem);


