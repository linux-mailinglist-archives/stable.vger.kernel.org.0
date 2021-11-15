Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FC0450F95
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbhKOScz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241766AbhKOSat (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E8CB632D0;
        Mon, 15 Nov 2021 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999118;
        bh=43O8LF6xd3J2tAqLZbQkVuDymC46QHQiHX+9ZdIwznE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyYXg8BIkgWShBs7nlEmnL9XLq1P/LfJi/MEmULaCDMxHy1ssrRQbwBts4HwXp7yr
         kMOi8JqZuA0biXe+Eks+EO2MDaiEMKepEB8e++uYOrjq28qPwdC8SHhIlphTlKZ9XH
         LybMZjDXxlteEpiyyiWegLBNxC84A1s+xND5eoJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.14 183/849] quota: correct error number in free_dqentry()
Date:   Mon, 15 Nov 2021 17:54:26 +0100
Message-Id: <20211115165426.365826324@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit d0e36a62bd4c60c09acc40e06ba4831a4d0bc75b upstream.

Fix the error path in free_dqentry(), pass out the error number if the
block to free is not correct.

Fixes: 1ccd14b9c271 ("quota: Split off quota tree handling into a separate file")
Link: https://lore.kernel.org/r/20211008093821.1001186-3-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/quota/quota_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -414,6 +414,7 @@ static int free_dqentry(struct qtree_mem
 		quota_error(dquot->dq_sb, "Quota structure has offset to "
 			"other block (%u) than it should (%u)", blk,
 			(uint)(dquot->dq_off >> info->dqi_blocksize_bits));
+		ret = -EIO;
 		goto out_buf;
 	}
 	ret = read_blk(info, blk, buf);


