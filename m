Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB451F13C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbfEOLWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbfEOLWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D606120843;
        Wed, 15 May 2019 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919351;
        bh=vVfQY6gZu/OlDcM6tuuouwA74XHWGJMpGlcOZoThUis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUd3jlIX9sMybvGlQhTq7gpWF77r2hUPHtxLPbt1KLupHPX6k4L0zq33vmNDjN2EQ
         Xr3p+EwztI8MrPmpKzm49g1evnVFatJ2aJC7GytxXzl0J+uCDFBZ2ue5cl6VEtotO9
         i1zu3Jm0/5CRPg9Vled1QJArZDhCJ66sSArUV3nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.19 006/113] kernfs: fix barrier usage in __kernfs_new_node()
Date:   Wed, 15 May 2019 12:54:57 +0200
Message-Id: <20190515090653.700227815@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Parri <andrea.parri@amarulasolutions.com>

commit 998267900cee901c5d1dfa029a6304d00acbc29f upstream.

smp_mb__before_atomic() can not be applied to atomic_set().  Remove the
barrier and rely on RELEASE synchronization.

Fixes: ba16b2846a8c6 ("kernfs: add an API to get kernfs node from inode number")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/kernfs/dir.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -650,11 +650,10 @@ static struct kernfs_node *__kernfs_new_
 	kn->id.generation = gen;
 
 	/*
-	 * set ino first. This barrier is paired with atomic_inc_not_zero in
+	 * set ino first. This RELEASE is paired with atomic_inc_not_zero in
 	 * kernfs_find_and_get_node_by_ino
 	 */
-	smp_mb__before_atomic();
-	atomic_set(&kn->count, 1);
+	atomic_set_release(&kn->count, 1);
 	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
 	RB_CLEAR_NODE(&kn->rb);
 


