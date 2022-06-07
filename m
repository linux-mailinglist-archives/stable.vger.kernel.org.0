Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA41540779
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348242AbiFGRri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349103AbiFGRqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A77462FD;
        Tue,  7 Jun 2022 10:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE58615F5;
        Tue,  7 Jun 2022 17:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8894DC341C8;
        Tue,  7 Jun 2022 17:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623406;
        bh=1fLzDA9P3oPmWoVT/PenFt81kH0oQvPzFPy+yKour2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3qxI0BWKokBh/OMH5ekxFoUKQFjZ3C/bXO/rFAKiy4A/FxzpUiA/YW8xmJXk5cVV
         e/5/OuzdHRgKhcFmFAHISyT8IX0dW63SfPOloJrjA+N5fXaFNuGiZs5hmqWp4jRiqI
         8A9FMzjCvn1bBVEW/E56p0EihHVQ0tHMZivPVmsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Yang <yiyang13@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.10 405/452] xtensa/simdisk: fix proc_read_simdisk()
Date:   Tue,  7 Jun 2022 19:04:22 +0200
Message-Id: <20220607164920.628334952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
@@ -213,12 +213,18 @@ static ssize_t proc_read_simdisk(struct
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


