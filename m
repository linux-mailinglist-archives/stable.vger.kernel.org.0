Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F447F0E8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391454AbfHBJdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391450AbfHBJdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF17C217D6;
        Fri,  2 Aug 2019 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738433;
        bh=xiYu9wTxlylBJbnw1wZllJ2RAgrqKYutwJW4hPjzZOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHs2cLKaDBZSYZ6Lou0xcHZfw6UUPhwAHFohVhjJ3dP+fGSevN97YwztGKfIvQ5NE
         t4uW/F2/iw1l2dVA6fncq5PwbrF/UrlPljwtZZQzWMbwmtRnM/+eI5yk6YRjqqh4BT
         qKRTdOP2hh4Xz7IDpaVUo2RU+EmYEBx5zXAcIVLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 102/158] nfsd: increase DRC cache limit
Date:   Fri,  2 Aug 2019 11:28:43 +0200
Message-Id: <20190802092225.293756554@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 44d8660d3bb0a1c8363ebcb906af2343ea8e15f6 ]

An NFSv4.1+ client negotiates the size of its duplicate reply cache size
in the initial CREATE_SESSION request.  The server preallocates the
memory for the duplicate reply cache to ensure that we'll never fail to
record the response to a nonidempotent operation.

To prevent a few CREATE_SESSIONs from consuming all of memory we set an
upper limit based on nr_free_buffer_pages().  1/2^10 has been too
limiting in practice; 1/2^7 is still less than one percent.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index b6eb56d18568..0fa990f08daf 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -360,7 +360,7 @@ void nfsd_reset_versions(void)
  */
 static void set_max_drc(void)
 {
-	#define NFSD_DRC_SIZE_SHIFT	10
+	#define NFSD_DRC_SIZE_SHIFT	7
 	nfsd_drc_max_mem = (nr_free_buffer_pages()
 					>> NFSD_DRC_SIZE_SHIFT) * PAGE_SIZE;
 	nfsd_drc_mem_used = 0;
-- 
2.20.1



