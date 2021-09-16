Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2981740E4CB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346446AbhIPRFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347946AbhIPRBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF53361AFA;
        Thu, 16 Sep 2021 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809983;
        bh=aYEm+ox7E1O6AVgVAzCjTSBJv3lZTPILbTDN7E0G+dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hb8y7tob3iNeoATgRbbQDpXVnkqEkuleBRIVyRr4dmC/G8MqgEzyZI9vqrPXu0qsU
         inVWKR+Ukjw7az2xJ+RCyIMcQNZOUaFrNBoHB9e/JB3sDuHG+xniX/ANxEUbt5b69l
         MD/nh80ZS4QqfLfT2XyQ3QLZ8SBjF5oAhG6enDzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 313/380] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu, 16 Sep 2021 18:01:10 +0200
Message-Id: <20210916155814.705312574@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index a92a1fb7cb52..4c22f73b3123 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -889,7 +889,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2



