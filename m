Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557BB794BA
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfG2Tew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388488AbfG2Teu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75ABE21773;
        Mon, 29 Jul 2019 19:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428889;
        bh=cuj6gjrv7yJRiT+f42miZQVAU+p3pGlzJe2vlggRx0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQaZ0Q5Mcm9gERxUZHC2dSVlTVXDCBIi49TQCh6wY/8DypgXd7M5m9FvMGTERR7Zn
         UuYHehmS7NTEBORCY24awTdo267B6NDnq+AIf+ZOV9EXGshJfgLCZBTz7GNgLP8CAt
         swu4Sh5bB8JXEOZnjb8CuBOvk4vi2RqGwk6KUnNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 217/293] nfsd: increase DRC cache limit
Date:   Mon, 29 Jul 2019 21:21:48 +0200
Message-Id: <20190729190841.137329436@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index e02bd2783124..4a9e0fb634b6 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -447,7 +447,7 @@ void nfsd_reset_versions(void)
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



