Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4099E114
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbfH0IJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbfH0IEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B55206BF;
        Tue, 27 Aug 2019 08:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893085;
        bh=mGsmKSX+IlSa1ev9wq4Chj9N3qmg7Kpn0DmErXx39i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqJv62ukpiDOIPwEuBo1pWwl0Mq7llTFjmY6n+mIXclFZLw1Cp+H9qQj+kZsHWNPc
         uLioUwrZTH3vnJbkT8B0nfLJuts9NdtZPCYOcGdMqGwPpPL2zrp9VtTZmJPZCgPZL7
         Z4BPsVtlPvfdY83WzsQAvRkdKvKV94IlOvd7BlVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erqi Chen <chenerqi@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.2 116/162] ceph: clear page dirty before invalidate page
Date:   Tue, 27 Aug 2019 09:50:44 +0200
Message-Id: <20190827072742.457519086@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erqi Chen <chenerqi@gmail.com>

commit c95f1c5f436badb9bb87e9b30fd573f6b3d59423 upstream.

clear_page_dirty_for_io(page) before mapping->a_ops->invalidatepage().
invalidatepage() clears page's private flag, if dirty flag is not
cleared, the page may cause BUG_ON failure in ceph_set_page_dirty().

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/40862
Signed-off-by: Erqi Chen <chenerqi@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/addr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -912,8 +912,9 @@ get_more_pages:
 			if (page_offset(page) >= ceph_wbc.i_size) {
 				dout("%p page eof %llu\n",
 				     page, ceph_wbc.i_size);
-				if (ceph_wbc.size_stable ||
-				    page_offset(page) >= i_size_read(inode))
+				if ((ceph_wbc.size_stable ||
+				    page_offset(page) >= i_size_read(inode)) &&
+				    clear_page_dirty_for_io(page))
 					mapping->a_ops->invalidatepage(page,
 								0, PAGE_SIZE);
 				unlock_page(page);


