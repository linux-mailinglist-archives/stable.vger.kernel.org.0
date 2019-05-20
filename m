Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782DF233B3
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfETMTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732272AbfETMTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD64320815;
        Mon, 20 May 2019 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354792;
        bh=Uvs3clkJNKhmVbhA9rwlfctk+Ze2Df4btxTxQ9DOH5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nk6ysGLH2bshkMEmoCl5qpA4TvBc47QES2UgEwwDxmasyLnu401W4OWCjmm4dKgMB
         7SS7eoI3Z1hyINo7Tc/b9DWHKaeOfNwTQVeC/Wi44qKtT9hgjnZXVF/vFvMBf68+vy
         BoSMyydWyJZv3gNZyvePWur/Bb5hbn/e35dxXRmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.14 43/63] ext4: avoid drop reference to iloc.bh twice
Date:   Mon, 20 May 2019 14:14:22 +0200
Message-Id: <20190520115235.831144044@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 8c380ab4b7b59c0c602743810be1b712514eaebc upstream.

The reference to iloc.bh has been dropped in ext4_mark_iloc_dirty.
However, the reference is dropped again if error occurs during
ext4_handle_dirty_metadata, which may result in use-after-free bugs.

Fixes: fb265c9cb49e("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -849,6 +849,7 @@ static int add_new_gdb(handle_t *handle,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 	if (unlikely(err)) {
 		ext4_std_error(sb, err);
+		iloc.bh = NULL;
 		goto errout;
 	}
 	brelse(dind);


