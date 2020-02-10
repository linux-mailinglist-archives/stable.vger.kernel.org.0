Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F8157864
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgBJNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbgBJMjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DC021739;
        Mon, 10 Feb 2020 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338379;
        bh=XeZUf+5UvoFoopetZByLEqxrHfZMmM/J/neN3auxS/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxvWL2c5sZlB68Syfgd+1vVsS8rn4/PO0eLYcxZvJSmUHlOO0Vei5wNmP8ZgZxGge
         P6BfuyZSXl7PDV/jlRlz71q0ZvAn9DDrvOfZkagc8budehrVs+YHMXbGmUW/vc81ry
         U/Pb0XGbYewBv7wUfxJUTmwwc27UPFWtYgMBADQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yang <richardw.yang@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 057/367] mm/migrate.c: also overwrite error when it is bigger than zero
Date:   Mon, 10 Feb 2020 04:29:30 -0800
Message-Id: <20200210122429.349456433@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

commit dfe9aa23cab7880a794db9eb2d176c00ed064eb6 upstream.

If we get here after successfully adding page to list, err would be 1 to
indicate the page is queued in the list.

Current code has two problems:

  * on success, 0 is not returned
  * on error, if add_page_for_migratioin() return 1, and the following err1
    from do_move_pages_to_node() is set, the err1 is not returned since err
    is 1

And these behaviors break the user interface.

Link: http://lkml.kernel.org/r/20200119065753.21694-1-richardw.yang@linux.intel.com
Fixes: e0153fc2c760 ("mm: move_pages: return valid node id in status if the page is already on the target node").
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1676,7 +1676,7 @@ out_flush:
 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
 	if (!err1)
 		err1 = store_status(status, start, current_node, i - start);
-	if (!err)
+	if (err >= 0)
 		err = err1;
 out:
 	return err;


