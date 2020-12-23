Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA4A2E1E2E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgLWPeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgLWPef (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341962333E;
        Wed, 23 Dec 2020 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737602;
        bh=kt0xTeUibXljMK23wxOSDTcl7QyfThsiz0vNCMOrBoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4W5UffS9aQYApOdtCQcteOpmeqoBARl6TF6VlbPYg0UIwWctQm5jp+3hzK2SYLFA
         hWDbJN7SC2jY5dEEQIOx1AIPJOiYH5ZpUyfeI/jZKoLqB0QCe//EuUlSWI/qG9uy0M
         9VINtnfgcyIeXqGuDpV+uWLvb3FyfRp3EzBYsh1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Yang <jiayang5@huawei.com>,
        Jack Qiu <jack.qiu@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 25/40] f2fs: init dirty_secmap incorrectly
Date:   Wed, 23 Dec 2020 16:33:26 +0100
Message-Id: <20201223150516.767859570@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Qiu <jack.qiu@huawei.com>

commit 5335bfc6eb688344bfcd4b4133c002c0ae0d0719 upstream.

section is dirty, but dirty_secmap may not set

Reported-by: Jia Yang <jiayang5@huawei.com>
Fixes: da52f8ade40b ("f2fs: get the right gc victim section when section has several segments")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4544,7 +4544,7 @@ static void init_dirty_segmap(struct f2f
 		return;
 
 	mutex_lock(&dirty_i->seglist_lock);
-	for (segno = 0; segno < MAIN_SECS(sbi); segno += blks_per_sec) {
+	for (segno = 0; segno < MAIN_SEGS(sbi); segno += sbi->segs_per_sec) {
 		valid_blocks = get_valid_blocks(sbi, segno, true);
 		secno = GET_SEC_FROM_SEG(sbi, segno);
 


