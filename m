Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9702A5699
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbgKCU7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733067AbgKCU7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861F322403;
        Tue,  3 Nov 2020 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437147;
        bh=10E+evXaSoanrGML/WlMAmxK4soRQKnBX3Wuv12W+X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDX/dvqZ8xfQ3qmrC9t+PPyJOd4PWNqkcrKRfsuWjC8rQmTkKaljqDl4vv1ylkBTK
         dYJ8I3fpi+J3L/NkuTvMvj3f8C+OZ41P+N5K0Sk+MPn8dWg3ncDCs53VtjSGwid2/b
         B0f6zvtzzkg/crQgb4f8ooUNP62nwTeD/8CV7apw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 167/214] ubifs: dent: Fix some potential memory leaks while iterating entries
Date:   Tue,  3 Nov 2020 21:36:55 +0100
Message-Id: <20201103203306.421035361@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -1123,6 +1123,7 @@ int dbg_check_dir(struct ubifs_info *c,
 			err = PTR_ERR(dent);
 			if (err == -ENOENT)
 				break;
+			kfree(pdent);
 			return err;
 		}
 


