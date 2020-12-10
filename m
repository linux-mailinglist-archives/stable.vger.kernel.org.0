Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743CD2D607D
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390823AbgLJOi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:38:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391176AbgLJOiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.9 49/75] dm: fix double RCU unlock in dm_dax_zero_page_range() error path
Date:   Thu, 10 Dec 2020 15:27:14 +0100
Message-Id: <20201210142608.478512719@linuxfoundation.org>
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

commit f05c4403db5bba881d4964e731f6da35be46aabd upstream.

Remove redundant dm_put_live_table() in dm_dax_zero_page_range() error
path to fix sparse warning:
drivers/md/dm.c:1208:9: warning: context imbalance in 'dm_dax_zero_page_range' - unexpected unlock

Fixes: cdf6cdcd3b99a ("dm,dax: Add dax zero_page_range operation")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1219,11 +1219,9 @@ static int dm_dax_zero_page_range(struct
 		 * ->zero_page_range() is mandatory dax operation. If we are
 		 *  here, something is wrong.
 		 */
-		dm_put_live_table(md, srcu_idx);
 		goto out;
 	}
 	ret = ti->type->dax_zero_page_range(ti, pgoff, nr_pages);
-
  out:
 	dm_put_live_table(md, srcu_idx);
 


