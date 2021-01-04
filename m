Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00642E9AA5
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbhADQAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbhADQAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DC93224DF;
        Mon,  4 Jan 2021 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775972;
        bh=DK+GjoiDKYtNH/n2j3QAqOOcFpT8NO9ECbL/nYYFxrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFICP6Dw5nQRtqScX9MFq9jGoZeqo4A62EKy3EAuWRUuJs0IIHAcL+uUV7MplBVcK
         NdSiHsdeBgNWzzjk5Fij0C8yYseDcO8GQB3OPyu76PLcx1ECPo8EIjQQxY8N85mvVC
         D/yx1OXdTHpyrPXee6ER7GwxuOC8EPEHxNr67ykM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Vigor <kvigor@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 02/47] md/raid10: initialize r10_bio->read_slot before use.
Date:   Mon,  4 Jan 2021 16:57:01 +0100
Message-Id: <20210104155705.863822994@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -1145,7 +1145,7 @@ static void raid10_read_request(struct m
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1510,6 +1510,7 @@ static void __make_request(struct mddev
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
 
 	if (bio_data_dir(bio) == READ)


