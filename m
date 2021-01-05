Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8815C2EA749
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbhAEJ2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:28:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbhAEJ2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:28:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 551AC20756;
        Tue,  5 Jan 2021 09:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838871;
        bh=iVFB+GZCwJ/BkBhCbVB1SZVFE5aUB1+vU0lDPw6bRIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtdzyPZTFrThbKBojrpAMyNdzdn4g4OUAr6KW+uWKaQDHdXw8Y2RqS7R3ufk8jzjU
         YP7iSbU29kwSbx4Zy1mWBfSAeQuyPIrtPUgULAp7XS8ItgZotiKTLUTSDqYEy1hMON
         UNhq6IUpJrsQQcFg8pWljVhxpjyK6J2l3p2YPyxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Vigor <kvigor@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.19 01/29] md/raid10: initialize r10_bio->read_slot before use.
Date:   Tue,  5 Jan 2021 10:28:47 +0100
Message-Id: <20210105090818.692040189@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Vigor <kvigor@gmail.com>

commit 93decc563637c4288380912eac0eb42fb246cc04 upstream.

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Cc: stable@vger.kernel.org
Signed-off-by: Kevin Vigor <kvigor@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1138,7 +1138,7 @@ static void raid10_read_request(struct m
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1547,6 +1547,7 @@ static void __make_request(struct mddev
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
 
 	if (bio_data_dir(bio) == READ)


