Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F395122EE54
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgG0OGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0OGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:06:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C6920775;
        Mon, 27 Jul 2020 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858812;
        bh=Mb9rP4LI2vXmW+8anhuT9s+wMWwNZL182QmZnUFU9R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqjNDkAguYOYXCK5yyWsXiuwzYC/Yis8hS23u3Ha9POh48a/zPLN+I1nyq//Yk3Mi
         DpCtpycqPMfFHsBSu5MbEQXXo48bu22WQryAMHhkbsYZBVqZny8vFWpvsJCiL4NfyO
         qEsDYU0WyLdv4OeOTW94qiyih0nImqbdsnXVeCEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Robbie Ko <robbieko@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 20/64] btrfs: fix page leaks after failure to lock page for delalloc
Date:   Mon, 27 Jul 2020 16:03:59 +0200
Message-Id: <20200727134912.046122358@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

commit 5909ca110b29aa16b23b52b8de8d3bb1035fd738 upstream.

When locking pages for delalloc, we check if it's dirty and mapping still
matches. If it does not match, we need to return -EAGAIN and release all
pages. Only the current page was put though, iterate over all the
remaining pages too.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1721,7 +1721,8 @@ static int __process_pages_contig(struct
 				if (!PageDirty(pages[i]) ||
 				    pages[i]->mapping != mapping) {
 					unlock_page(pages[i]);
-					put_page(pages[i]);
+					for (; i < ret; i++)
+						put_page(pages[i]);
 					err = -EAGAIN;
 					goto out;
 				}


