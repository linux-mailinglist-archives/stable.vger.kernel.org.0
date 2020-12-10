Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B0E2D5E16
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391219AbgLJOjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387589AbgLJOjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:13 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Shtepa <sergei.shtepa@veeam.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.9 48/75] dm: fix bug with RCU locking in dm_blk_report_zones
Date:   Thu, 10 Dec 2020 15:27:13 +0100
Message-Id: <20201210142608.431693504@linuxfoundation.org>
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

From: Sergei Shtepa <sergei.shtepa@veeam.com>

commit 89478335718c98557f10470a9bc5c555b9261c4e upstream.

The dm_get_live_table() function makes RCU read lock so
dm_put_live_table() must be called even if dm_table map is not found.

Fixes: e76239a3748c9 ("block: add a report_zones method")
Cc: stable@vger.kernel.org
Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -491,8 +491,10 @@ static int dm_blk_report_zones(struct ge
 		return -EAGAIN;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (!map)
-		return -EIO;
+	if (!map) {
+		ret = -EIO;
+		goto out;
+	}
 
 	do {
 		struct dm_target *tgt;


