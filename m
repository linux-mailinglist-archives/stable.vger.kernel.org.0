Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49A44A437A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359844AbiAaLVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50168 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359336AbiAaLQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8772461267;
        Mon, 31 Jan 2022 11:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63309C340F2;
        Mon, 31 Jan 2022 11:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627811;
        bh=X2NLHHrc8/3gNl+DOPHGYjac8IB7EXpwxxT1Q3LKgYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+aVqLcVlCHqhZQmaN77HcUa+ICZi3rL8ltU+LnXUpvYs6o8vQgSgu9vkNMDvh69h
         YKXjomCp7E/lqiYgTyjeZcJ5CPQBwZkWQzt0nQXdUZjnrptFeLvyDbIZj4FFR9rSbY
         ddmlo532oc3qjretz9H0nZcBDjoK9kScCsfuxmpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.16 033/200] ceph: properly put ceph_string reference after async create attempt
Date:   Mon, 31 Jan 2022 11:54:56 +0100
Message-Id: <20220131105234.680676359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 932a9b5870d38b87ba0a9923c804b1af7d3605b9 upstream.

The reference acquired by try_prep_async_create is currently leaked.
Ensure we put it.

Cc: stable@vger.kernel.org
Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -746,8 +746,10 @@ retry:
 				restore_deleg_ino(dir, req->r_deleg_ino);
 				ceph_mdsc_put_request(req);
 				try_async = false;
+				ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 				goto retry;
 			}
+			ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 			goto out_req;
 		}
 	}


