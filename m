Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E066D40E0EC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbhIPQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238703AbhIPQXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB35761502;
        Thu, 16 Sep 2021 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808956;
        bh=wm3vgGq28kagCEy8O6Nt9xmU1mL0EuDDPzYz6pRSOJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G85/ySwVyLr8JLaXcFID8EPGQeplFUOEeFxFhBiuxHOo8iAOFnAGwQPZdquOParCY
         CurmQaXS7VTK1MQM37cqW6tLwgwEFHvI2SZjbj9f6CHLTBGEgT3XGgjHWwEFtSvSwO
         K51XoVf5LsFxRrqDxXYD0gFGx+EiBJHxVB46c7MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/306] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu, 16 Sep 2021 17:59:57 +0200
Message-Id: <20210916155802.658764736@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit d72c74197b70bc3c95152f351a568007bffa3e11 ]

smb_buf is allocated by small_smb_init_no_tc(), and buf type is
CIFS_SMALL_BUFFER, so we should use cifs_small_buf_release() to
release it in failed path.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1a0298d1e7cd..d58c5ffeca0d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -888,7 +888,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2



