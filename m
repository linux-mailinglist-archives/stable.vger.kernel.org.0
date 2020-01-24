Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77EA1482D0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404322AbgAXLa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388654AbgAXLa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:57 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0646206D4;
        Fri, 24 Jan 2020 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865456;
        bh=ZS6jI65e74Mv6Xy/85nheZaEHl6XJF/PPFGmlmUx6S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbQCgiKNQn9tg+wuxwuC+x0HXN89iGO/e8NV7hTQobQZbseUfXKrJ6eYAl9LiqO/i
         afWyvnzmpp3EUAq1xHVtkf+i9oIE2rJANbyae29DUT+omxMb8jelQh1op6o+q7ljln
         /GT0aYmJMyWLkEM/rrXf/NKhnujtDoFwalL0rJxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 551/639] f2fs: fix error path of f2fs_convert_inline_page()
Date:   Fri, 24 Jan 2020 10:32:01 +0100
Message-Id: <20200124093158.210786925@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit e8c82c11c93d586d03d80305959527bcac383555 ]

In error path of f2fs_convert_inline_page(), we missed to truncate newly
reserved block in .i_addrs[0] once we failed in get_node_info(), fix it.

Fixes: 7735730d39d7 ("f2fs: fix to propagate error from __get_meta_page()")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 6bbb5f6801e26..3fe0dd5313903 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -133,6 +133,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 
 	err = f2fs_get_node_info(fio.sbi, dn->nid, &ni);
 	if (err) {
+		f2fs_truncate_data_blocks_range(dn, 1);
 		f2fs_put_dnode(dn);
 		return err;
 	}
-- 
2.20.1



