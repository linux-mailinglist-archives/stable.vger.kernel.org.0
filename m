Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33234122BE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346304AbhITSRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376856AbhITSOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCEC61A61;
        Mon, 20 Sep 2021 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158507;
        bh=FwCJDxS2o/rIPFeTfezYzRrapeG4sI24aIt9JPu/XhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4U2yGd1YkS4Skvt1nUYOEjvwqAUw5tixEGO5npIo23pBOfcEAT31PxqM1tfEF/o1
         3EDu1mfIBhXwN0g07bxvDLM6YPo24V3KEP8eG237f6mJReCCONyMvUPHX1exOgJQjk
         qLrw5IcRL2zd3XnMTibEQCw5e6v3w+1Oqm6vOHxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/260] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Mon, 20 Sep 2021 18:42:54 +0200
Message-Id: <20210920163936.408813658@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index 85bd644f9773..30f841a880ac 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -610,7 +610,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2



