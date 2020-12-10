Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08C42D6026
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbgLJPnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391274AbgLJOkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:12 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.9 70/75] dm writecache: remove BUG() and fail gracefully instead
Date:   Thu, 10 Dec 2020 15:27:35 +0100
Message-Id: <20201210142609.471194629@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 857c4c0a8b2888d806f4308c58f59a6a81a1dee9 upstream.

Building on arch/s390/ results in this build error:

cc1: some warnings being treated as errors
../drivers/md/dm-writecache.c: In function 'persistent_memory_claim':
../drivers/md/dm-writecache.c:323:1: error: no return statement in function returning non-void [-Werror=return-type]

Fix this by replacing the BUG() with an -EOPNOTSUPP return.

Fixes: 48debafe4f2f ("dm: add writecache target")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -319,7 +319,7 @@ err1:
 #else
 static int persistent_memory_claim(struct dm_writecache *wc)
 {
-	BUG();
+	return -EOPNOTSUPP;
 }
 #endif
 


