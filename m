Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA247CD7F1
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfJFRzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728611AbfJFRy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0F522466;
        Sun,  6 Oct 2019 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383968;
        bh=lcB1mFJcKFF8tbCYE5shlRbzQ7T708HoKSgtww14kP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgHLO9rUSmNjHgHcMYwDbplbKrycCoKgj1WxVYXgPdtriWCrgK4d2N85u0Iw6pEfb
         lXA3QanfuyXoYzDuY9OH3VscHtpdFfahr5H7xuAzcD0Kv4heGYMOk/Xm4+vNW65SCt
         2aaZsePRbk+d4z3JowGkj63VgATSuJUq591XymXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.3 161/166] dm zoned: fix invalid memory access
Date:   Sun,  6 Oct 2019 19:22:07 +0200
Message-Id: <20191006171226.412783993@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0c8e9c2d668278652af028c3cc068c65f66342f4 upstream.

Commit 75d66ffb48efb30f2dd42f041ba8b39c5b2bd115 ("dm zoned: properly
handle backing device failure") triggers a coverity warning:

---
 drivers/md/dm-zoned-target.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -134,8 +134,6 @@ static int dmz_submit_bio(struct dmz_tar
 
 	refcount_inc(&bioctx->ref);
 	generic_make_request(clone);
-	if (clone->bi_status == BLK_STS_IOERR)
-		return -EIO;
 
 	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
 		zone->wp_block += nr_blocks;


