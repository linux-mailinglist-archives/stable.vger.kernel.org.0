Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527F4A413C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348658AbiAaLDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49522 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358835AbiAaLBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A04C0B82A57;
        Mon, 31 Jan 2022 11:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09FAC340E8;
        Mon, 31 Jan 2022 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626911;
        bh=/sgwyjPGk2ekIOjkWWWkrHy58bJWv7F+ny5Cg039Gyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mo4sX6JV2TyPTm0hz14WHbsdFOj4JZhaX6NtgPUMVHSIv1pGuaA+TnyUFrzGuuXih
         M+qmGyv77iFLzo5TdjHguCt1dX3ESEIb0imx8HdRfXN5Pq8sJ89btoxlG+pYEbzfk6
         mMchDUOMV2U7UD020Lh1gPzkCAYx932Zc9DyNiBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 015/100] ceph: properly put ceph_string reference after async create attempt
Date:   Mon, 31 Jan 2022 11:55:36 +0100
Message-Id: <20220131105220.973722937@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
@@ -743,8 +743,10 @@ retry:
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


