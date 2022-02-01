Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09F44A638E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241886AbiBASSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:18:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51372 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241873AbiBASSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:18:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E3CDCE1A66;
        Tue,  1 Feb 2022 18:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD4CC340EC;
        Tue,  1 Feb 2022 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739480;
        bh=j+IhRbq4Cs2X1+PpGGO88TqMrMllX3nejWDyhD2ZKVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7xZlgLU5yPVuxZZI1Cg0hCMTcHMBMmjyuz6n4wTesCf5ovvPj7zrFZft/e/9/Riv
         67pz7CmSAY2UF361R96WE1ZGnLJpOPR4xmoskCSRmoACnmjE4IgGXDMrxWBWPrrB68
         o1YEWyIH/s0Zrw9DOxgI2zQUGZMrLC9aAdQ6wmTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 05/25] udf: Restore i_lenAlloc when inode expansion fails
Date:   Tue,  1 Feb 2022 19:16:29 +0100
Message-Id: <20220201180822.337788155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
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
@@ -320,6 +320,7 @@ int udf_expand_file_adinicb(struct inode
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
 	}
 	page_cache_release(page);


