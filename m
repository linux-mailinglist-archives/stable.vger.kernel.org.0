Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8256EF549
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 15:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbjDZNQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 09:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241125AbjDZNP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 09:15:56 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD74A5FC0;
        Wed, 26 Apr 2023 06:15:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 7C8E66017C;
        Wed, 26 Apr 2023 15:15:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682514952; bh=BkbDGciTS3W//1DGsvWYvladd4chFAo6enUQtEEQQqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3PBIre12N8S7+pAiYxpBnotF1xNuHJiB9WFD3DUQyy2zG+VLFAjHYCj0i4WEsu68
         xMLy5h2FG9SUC/UiN9CdAfMoVzO0TVINpx3ghAH3gn/tk1EX1a1LKnogP6QZ4+9gsq
         N8phvi94or/bweFqGAeEKvc9SqYGmSJDMJrBJ8uRzpqaoN3jdji/uX38SxeO3RSe37
         aKzRqvv8B/L6o5Znov3D9f8Ew9+MNk91ogjzZ9Toy99aLUwYI5HcGpr4pCNhtMQz+g
         3etOCjfPN1MM9Nm3ZLJlosGTBadZ6tnmfH2JH8ZXl3NK6rOBEcQivIQiUwlqA66yO0
         /u4MXMZRQDAYA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5dbKQDu-qTY3; Wed, 26 Apr 2023 15:15:50 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id 595406017E; Wed, 26 Apr 2023 15:15:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682514950; bh=BkbDGciTS3W//1DGsvWYvladd4chFAo6enUQtEEQQqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2PYGjp02QXGEwIrsbzABoB8RC9N63W+Au8q3DPzM6xAWOlUKfDgEYJZj2U/7/Iqe
         ANXorKJH9xllVago/Fo5zE0K6ETk4c775VIQi0letwp3q8Z8Ohk13ZdxHqxLEDuWNc
         Jl0/r1SJin0DWdxnJip+IPZg85KrbfhJ4h22X1DoZNUzlB5/ppKiTSa8CqJL39Ab/Z
         o8Cs7+KRfvogXfQx9VJtaLDdyK7k6P6jFNngjDqmbO/dysJPY8ukL8mt36OHpMiJ8H
         B3pv307BqdEiRfx9jyRRiT6meCiJhdE2N6q2OrsID/7TOYmPRmm4VHoXPADsVYZJ04
         vxSSJJyo53LwQ==
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        linux-kernel@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russ Weight <russell.h.weight@intel.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.i.king@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v5 2/3] test_firmware: fix a memory leak with reqs buffer
Date:   Wed, 26 Apr 2023 15:14:41 +0200
Message-Id: <20230426131438.16936-2-mirsad.todorovac@alu.unizg.hr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230426131438.16936-1-mirsad.todorovac@alu.unizg.hr>
References: <20230426131438.16936-1-mirsad.todorovac@alu.unizg.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan Carpenter spotted that test_fw_config->reqs will be leaked if
trigger_batched_requests_store() is called two or more times.
The same appears with trigger_batched_requests_async_store().

This bug wasn't trigger by the tests, but observed by Dan's visual
inspection of the code.

The recommended workaround was to return -EBUSY if test_fw_config->reqs
is already allocated.

Fixes: 7feebfa487b92 ("test_firmware: add support for request_firmware_into_buf")
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russ Weight <russell.h.weight@intel.com>
Cc: Tianfei Zhang <tianfei.zhang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kselftest@vger.kernel.org
Cc: stable@vger.kernel.org # v5.4
Suggested-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
 lib/test_firmware.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 35417e0af3f4..91b232ed3161 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -913,6 +913,11 @@ static ssize_t trigger_batched_requests_store(struct device *dev,
 
 	mutex_lock(&test_fw_mutex);
 
+	if (test_fw_config->reqs) {
+		rc = -EBUSY;
+		goto out_bail;
+	}
+
 	test_fw_config->reqs =
 		vzalloc(array3_size(sizeof(struct test_batched_req),
 				    test_fw_config->num_requests, 2));
@@ -1011,6 +1016,11 @@ ssize_t trigger_batched_requests_async_store(struct device *dev,
 
 	mutex_lock(&test_fw_mutex);
 
+	if (test_fw_config->reqs) {
+		rc = -EBUSY;
+		goto out_bail;
+	}
+
 	test_fw_config->reqs =
 		vzalloc(array3_size(sizeof(struct test_batched_req),
 				    test_fw_config->num_requests, 2));
-- 
2.30.2

