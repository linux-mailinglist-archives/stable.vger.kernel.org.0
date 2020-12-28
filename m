Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC38E2E3AC5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403942AbgL1Nlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391669AbgL1NlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D81C207C9;
        Mon, 28 Dec 2020 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162832;
        bh=kgnn3OX3Ha0ANEqkEYUXQQQ3PrttaXvaQuae7vSy3dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbOjcJ593+FfB5eTpgZoYu4+2to8zJ2+YvMRplQ83p4fCZupa5xUc3nwgO1FnTmG7
         /yKdCdisYzfyJp4sQHa5O+MsawtehqeWfZuSU6uvYHUnASEUEBA/k4xSqqpQHQkiK8
         /wNJ6n6Intp9ZGrJL2irVjtzN1eR2hWetGIJPpGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 069/453] quota: Sanity-check quota file headers on load
Date:   Mon, 28 Dec 2020 13:45:05 +0100
Message-Id: <20201228124940.566777525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -159,6 +159,25 @@ static int v2_read_file_info(struct supe
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


