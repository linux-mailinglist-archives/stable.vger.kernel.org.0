Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35303441E6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhCVMgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhCVMf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53499619A3;
        Mon, 22 Mar 2021 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416522;
        bh=1ZlYgbyX380SR7QuyvLk98g81AJFWAdBEg3n63V3xE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8Lg4ynfxyVjC9B9BZ6YH9FJc8f/2iencbM85kW9gh5J9K4RXK7jszZYNWkAwxwyC
         ZtukdnxYmx2ijferaLbi98/t5eSIh5WWyKit3AG9I2Dk6kSwcQ2EwIEt/S28CMjTzM
         ta/nXsbhdA31QdKiLeJh+XEH/X8VvmJ19kLbuoZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.10 018/157] zonefs: fix to update .i_wr_refcnt correctly in zonefs_open_zone()
Date:   Mon, 22 Mar 2021 13:26:15 +0100
Message-Id: <20210322121934.354265899@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 6980d29ce4da223ad7f0751c7f1d61d3c6b54ab3 upstream.

In zonefs_open_zone(), if opened zone count is larger than
.s_max_open_zones threshold, we missed to recover .i_wr_refcnt,
fix this.

Fixes: b5c00e975779 ("zonefs: open/close zone on file open/close")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1032,9 +1032,7 @@ static int zonefs_open_zone(struct inode
 
 	mutex_lock(&zi->i_truncate_mutex);
 
-	zi->i_wr_refcnt++;
-	if (zi->i_wr_refcnt == 1) {
-
+	if (!zi->i_wr_refcnt) {
 		if (atomic_inc_return(&sbi->s_open_zones) > sbi->s_max_open_zones) {
 			atomic_dec(&sbi->s_open_zones);
 			ret = -EBUSY;
@@ -1044,7 +1042,6 @@ static int zonefs_open_zone(struct inode
 		if (i_size_read(inode) < zi->i_max_size) {
 			ret = zonefs_zone_mgmt(inode, REQ_OP_ZONE_OPEN);
 			if (ret) {
-				zi->i_wr_refcnt--;
 				atomic_dec(&sbi->s_open_zones);
 				goto unlock;
 			}
@@ -1052,6 +1049,8 @@ static int zonefs_open_zone(struct inode
 		}
 	}
 
+	zi->i_wr_refcnt++;
+
 unlock:
 	mutex_unlock(&zi->i_truncate_mutex);
 


