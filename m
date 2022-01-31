Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40754A40F7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiAaLBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358591AbiAaLAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A54C0613E5;
        Mon, 31 Jan 2022 02:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D9060B28;
        Mon, 31 Jan 2022 10:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED62C340F0;
        Mon, 31 Jan 2022 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626777;
        bh=etwDj2ZJLh6nqqlIe8jncPRFjBV+R7ONKL8aFnttvpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/rjBsjhhrjtElqV1Mw1jXK8vs8tgJKOFKnLkMUMM9z+R6+rIGdbz0FR2n6sL8jgN
         ixY9iH1M8ij3pBcNaxvDeYjpRDk8sk/rPgEK7WsFtQBQb1sEJtETJjW+PeZ6PiSKpW
         TVvedb6A7ZpjrmjhO9Tbvun09OzP/Vg43n7wDIiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 04/64] udf: Restore i_lenAlloc when inode expansion fails
Date:   Mon, 31 Jan 2022 11:55:49 +0100
Message-Id: <20220131105215.797442396@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit ea8569194b43f0f01f0a84c689388542c7254a1f upstream.

When we fail to expand inode from inline format to a normal format, we
restore inode to contain the original inline formatting but we forgot to
set i_lenAlloc back. The mismatch between i_lenAlloc and i_size was then
causing further problems such as warnings and lost data down the line.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 7e49b6f2480c ("udf: Convert UDF to new truncate calling sequence")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -318,6 +318,7 @@ int udf_expand_file_adinicb(struct inode
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	put_page(page);


