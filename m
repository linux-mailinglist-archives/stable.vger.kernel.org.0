Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFA1D8492
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbgERSMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732646AbgERSDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E8D120826;
        Mon, 18 May 2020 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825020;
        bh=UrFvnLWyjE9xLwrZKpHj0CzIsvElMLgdmAdsIngRRMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWrKz4Iumyf1U79rbqb1sYLwnrvluVVoTLATN4Xs928JKQ5NglqYo2F//MItpSEnr
         1/4sTgRVhbA5jvx4SfyqmwFgbqncL1YtusRu7JtKs5LicTxqGqgTjRwZPPw88p+k3F
         jtScLnbdptMuIZ4pS08e8HB7BZA7I6zdv12m4LJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 080/194] bpf: Fix error return code in map_lookup_and_delete_elem()
Date:   Mon, 18 May 2020 19:36:10 +0200
Message-Id: <20200518173538.431313123@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 7f645462ca01d01abb94d75e6768c8b3ed3a188b ]

Fix to return negative error code -EFAULT from the copy_to_user() error
handling case instead of 0, as done elsewhere in this function.

Fixes: bd513cd08f10 ("bpf: add MAP_LOOKUP_AND_DELETE_ELEM syscall")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200430081851.166996-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3b92aea18ae75..e04ea4c8f9358 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1480,8 +1480,10 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	if (err)
 		goto free_value;
 
-	if (copy_to_user(uvalue, value, value_size) != 0)
+	if (copy_to_user(uvalue, value, value_size) != 0) {
+		err = -EFAULT;
 		goto free_value;
+	}
 
 	err = 0;
 
-- 
2.20.1



