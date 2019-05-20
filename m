Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2822023620
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbfETM3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389448AbfETM3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DFB20675;
        Mon, 20 May 2019 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355341;
        bh=gjf+mOszHMrKvbqtvIw9132vFb8gT0KeTwcDppoOEo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEsjQLOAHCpyOJ1rWXKv6UIyvWJlm92YRr8vxn8h4m9Al+/Wf9f3t26ve9BBPgQ3j
         8m3cAycaS4T7YTZoH9WBqSliMwcbL+bPNd/qCudi1xI/L7hNlFzMMp54tcx1x+WAtA
         1Su5lWbvHR3eo2mPt3RWh3KOwOOD0JK59omjlOvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.0 082/123] ext4: make sanity check in mballoc more strict
Date:   Mon, 20 May 2019 14:14:22 +0200
Message-Id: <20190520115250.300766252@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 31562b954b60f02acb91b7349dc6432d3f8c3c5f upstream.

The sanity check in mb_find_extent() only checked that returned extent
does not extend past blocksize * 8, however it should not extend past
EXT4_CLUSTERS_PER_GROUP(sb). This can happen when clusters_per_group <
blocksize * 8 and the tail of the bitmap is not properly filled by 1s
which happened e.g. when ancient kernels have grown the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1539,7 +1539,7 @@ static int mb_find_extent(struct ext4_bu
 		ex->fe_len += 1 << order;
 	}
 
-	if (ex->fe_start + ex->fe_len > (1 << (e4b->bd_blkbits + 3))) {
+	if (ex->fe_start + ex->fe_len > EXT4_CLUSTERS_PER_GROUP(e4b->bd_sb)) {
 		/* Should never happen! (but apparently sometimes does?!?) */
 		WARN_ON(1);
 		ext4_error(e4b->bd_sb, "corruption or bug in mb_find_extent "


