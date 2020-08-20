Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA3A24C048
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgHTNxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgHTJYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239B522CF6;
        Thu, 20 Aug 2020 09:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915447;
        bh=hKw4VeEPTvlU9LP6XXahCcYoetS6SUJD6tZ/nSvmgRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPtI0BEjeMUjWA0aI0Q0iQAWGx80fQKRRJHxpkfj1VcJuFdSGmElNPZoAFvxwQpea
         DzS9rHJVx2fA4A+Y4jlbeTOBmXClqeMU3k27PUZNbmUG3VNERvxrWRHsPUWI5MH1k7
         KQbmCXvzumKTs5IQGwmM8E7MtQ6JM1Oqpl1fqEMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 017/232] btrfs: ref-verify: fix memory leak in add_block_entry
Date:   Thu, 20 Aug 2020 11:17:48 +0200
Message-Id: <20200820091613.569935200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit d60ba8de1164e1b42e296ff270c622a070ef8fe7 upstream.

clang static analysis flags this error

fs/btrfs/ref-verify.c:290:3: warning: Potential leak of memory pointed to by 're' [unix.Malloc]
                kfree(be);
                ^~~~~

The problem is in this block of code:

	if (root_objectid) {
		struct root_entry *exist_re;

		exist_re = insert_root_entry(&exist->roots, re);
		if (exist_re)
			kfree(re);
	}

There is no 'else' block freeing when root_objectid is 0. Add the
missing kfree to the else branch.

Fixes: fd708b81d972 ("Btrfs: add a extent ref verify tool")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ref-verify.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -286,6 +286,8 @@ static struct block_entry *add_block_ent
 			exist_re = insert_root_entry(&exist->roots, re);
 			if (exist_re)
 				kfree(re);
+		} else {
+			kfree(re);
 		}
 		kfree(be);
 		return exist;


