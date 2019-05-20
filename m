Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9297523621
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389779AbfETM3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389773AbfETM26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7B220815;
        Mon, 20 May 2019 12:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355338;
        bh=L/Cv3EAR9jLgZ9/NL7/jp4JloC3gs6Kc1Nk8kU4hPu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SK2pPgzKktoB3kiUohi9nnyIfOOazAf4AOPEzCVDmBtifWDOMOnvQGIyc2kxBdAiP
         F4Q/nVLShO4eolAo6IWWdjgdrtsNHoYW45SZ91CBbBM35V9cHCAYOQQnv2OmR+xSh9
         7YT8x/p+d48l0q79kEcsuFf4+XGCwumYMLvF/sWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Ren <renzhen@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 5.0 081/123] jbd2: check superblock mapped prior to committing
Date:   Mon, 20 May 2019 14:14:21 +0200
Message-Id: <20190520115250.234230887@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 742b06b5628f2cd23cb51a034cb54dc33c6162c5 upstream.

We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
before unmounting ext4 filesystem.

The typical chain of events leading to the BUG:
jbd2_write_superblock
  submit_bh
    submit_bh_wbc
      BUG_ON(!buffer_mapped(bh));

The block device is removed and all the pages are invalidated. JBD2
was trying to write journal superblock to the block device which is
no longer present.

Fix this by checking the journal superblock's buffer head prior to
submitting.

Reported-by: Eric Ren <renzhen@linux.alibaba.com>
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/journal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1366,6 +1366,10 @@ static int jbd2_write_superblock(journal
 	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
+	/* Buffer got discarded which means block device got invalidated */
+	if (!buffer_mapped(bh))
+		return -EIO;
+
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);


