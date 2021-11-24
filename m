Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7809745BF85
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346053AbhKXM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:59:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346139AbhKXM4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:56:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3FC6159A;
        Wed, 24 Nov 2021 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757165;
        bh=fKBZ8UgLuP8nM0/2CUs62qmfFwcH+GDa/HbJimkmt64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Miowu+ZZxEA+AW6hG/Wr+f3wBMZstXrFPIpP0mCtANxM3OuBfpZRWh6XYOtHA7UIW
         ZuNsnSWLwiLrAQLGkemYrzSUSN5fZP0SBMVyBfR7rglzlHlg90WoF2u/t/657UPvgC
         phizn+28pznRjVWlFQSjVII5hYeMag13fWOlUDOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 077/323] quota: correct error number in free_dqentry()
Date:   Wed, 24 Nov 2021 12:54:27 +0100
Message-Id: <20211124115721.477329741@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -422,6 +422,7 @@ static int free_dqentry(struct qtree_mem
 		quota_error(dquot->dq_sb, "Quota structure has offset to "
 			"other block (%u) than it should (%u)", blk,
 			(uint)(dquot->dq_off >> info->dqi_blocksize_bits));
+		ret = -EIO;
 		goto out_buf;
 	}
 	ret = read_blk(info, blk, buf);


