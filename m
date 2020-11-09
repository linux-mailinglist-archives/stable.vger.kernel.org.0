Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6706A2ABC97
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgKINjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730662AbgKINDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293C922210;
        Mon,  9 Nov 2020 13:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926985;
        bh=eSPdUNSrzMNvWnZGQeWWlmUQk5bq+1LKzjc1HE76wjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3SVTrQatFU/Y1ox7G9gTv16p8Pz0S03a9UE0FmlLxb4SqJa0YZVAhZBUL8/OlB5j
         +btv4YxrsyyTXcTnJ1FP3qnJ1Zd+QmGofhckuYvO1m49qv02awfu3S716yB7G6Fspi
         LrWz0nITyMfbLbfGKh/QnDdCwC0tAjwEAEYqc90U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.9 071/117] ubifs: dent: Fix some potential memory leaks while iterating entries
Date:   Mon,  9 Nov 2020 13:54:57 +0100
Message-Id: <20201109125029.052423941@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 58f6e78a65f1fcbf732f60a7478ccc99873ff3ba upstream.

Fix some potential memory leaks in error handling branches while
iterating dent entries. For example, function dbg_check_dir()
forgets to free pdent if it exists.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/debug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -1125,6 +1125,7 @@ int dbg_check_dir(struct ubifs_info *c,
 			err = PTR_ERR(dent);
 			if (err == -ENOENT)
 				break;
+			kfree(pdent);
 			return err;
 		}
 


