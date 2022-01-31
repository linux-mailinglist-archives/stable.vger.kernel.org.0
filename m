Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F104A4284
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359835AbiAaLMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377388AbiAaLJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB38C0604EE;
        Mon, 31 Jan 2022 03:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E6F660E76;
        Mon, 31 Jan 2022 11:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AECC340EE;
        Mon, 31 Jan 2022 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627253;
        bh=TEQ4QtW897KUpyACEqK/a2F+QVmtupwqDs42RMlB7oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LjTjTWJ2WKsaJDBD9aHrTwuTAJ5hplR8xBao1yrLrN4PtKEwXLHqUPo1yXLSOC7O
         am7i/z8Ps2YGV6o1qlcGzuPzu57PhdMrEQvpS12nP52x8tWXPXsUljt9Nmziy0BmCs
         e1ja2nwmFVuo4K+b0awPNkGH+TtHkNsXk37SGfCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 023/171] ceph: properly put ceph_string reference after async create attempt
Date:   Mon, 31 Jan 2022 11:54:48 +0100
Message-Id: <20220131105230.806451264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -744,8 +744,10 @@ retry:
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


