Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8488254101F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351518AbiFGTSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355372AbiFGTPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F5B195977;
        Tue,  7 Jun 2022 11:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C79F617A5;
        Tue,  7 Jun 2022 18:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BCAC34115;
        Tue,  7 Jun 2022 18:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625261;
        bh=vc2Ihg+QQoHKkXpvdNov7Zm6/WKLnpLxTBzcDHpJAtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URxFhoOdXLHGU330Uu31DEk7b2jLGsvh8jromquHPtM27FyEUQPEKZ4Yjlcq+RLKy
         7DbLQ0WbiTk1pRwIdk+kdNWlRPYjg+DyKDB0Ck4aWFFISIEJ34C73YSvaudlPrd1Jg
         zi4rezjiHJx0/0N6fZpe6wp8cSQRAhCMrEDXt3Hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Yang <yiyang13@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.15 624/667] xtensa/simdisk: fix proc_read_simdisk()
Date:   Tue,  7 Jun 2022 19:04:49 +0200
Message-Id: <20220607164953.384356628@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Yang <yiyang13@huawei.com>

commit b011946d039d66bbc7102137e98cc67e1356aa87 upstream.

The commit a69755b18774 ("xtensa simdisk: switch to proc_create_data()")
split read operation into two parts, first retrieving the path when it's
non-null and second retrieving the trailing '\n'. However when the path
is non-null the first simple_read_from_buffer updates ppos, and the
second simple_read_from_buffer returns 0 if ppos is greater than 1 (i.e.
almost always). As a result reading from that proc file is almost always
empty.

Fix it by making a temporary copy of the path with the trailing '\n' and
using simple_read_from_buffer on that copy.

Cc: stable@vger.kernel.org
Fixes: a69755b18774 ("xtensa simdisk: switch to proc_create_data()")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/platforms/iss/simdisk.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -212,12 +212,18 @@ static ssize_t proc_read_simdisk(struct
 	struct simdisk *dev = PDE_DATA(file_inode(file));
 	const char *s = dev->filename;
 	if (s) {
-		ssize_t n = simple_read_from_buffer(buf, size, ppos,
-							s, strlen(s));
-		if (n < 0)
-			return n;
-		buf += n;
-		size -= n;
+		ssize_t len = strlen(s);
+		char *temp = kmalloc(len + 2, GFP_KERNEL);
+
+		if (!temp)
+			return -ENOMEM;
+
+		len = scnprintf(temp, len + 2, "%s\n", s);
+		len = simple_read_from_buffer(buf, size, ppos,
+					      temp, len);
+
+		kfree(temp);
+		return len;
 	}
 	return simple_read_from_buffer(buf, size, ppos, "\n", 1);
 }


