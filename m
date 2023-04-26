Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE76EF54E
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241098AbjDZNQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 09:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbjDZNQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 09:16:17 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F904659F;
        Wed, 26 Apr 2023 06:16:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 35C846017C;
        Wed, 26 Apr 2023 15:16:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682514974; bh=DplkcwFmSKllgiewQPCLoUNazOClR1ZbTBiZSdEqy0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLF34zZySbrMIOar5hbB9l+LuyXzqgbjgZcvmCeF6wi62cxiSBVLdnN33YdtamlH7
         cxz82IsYoaZRnYV0sAcYqYPs1h2BS4xFbwHv/lb2vTonHxSu9DqH25Xgz8rtlCKLTI
         tEEmgSqjGTS/zSGn8o2mMkarG1eHI3oxjCTTSntsDb7cib6Yp0EEQsreaud/UKc+Su
         6yRps4q37snvK5dKB0mjdVu0eP4lDtE9J8Z6zbw1uj7LyHB66qCgBh6XYkk4OqaaOK
         J2qpvxyNE/CDHmFDdWbokqReuiI/Xvi0AR0M2bA/lPRVT45bJ44IDzw8aGrGdM7CRp
         oMTYHbrvrkGpA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1v-Us3qcu3JB; Wed, 26 Apr 2023 15:16:11 +0200 (CEST)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id BF8626017E; Wed, 26 Apr 2023 15:16:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682514971; bh=DplkcwFmSKllgiewQPCLoUNazOClR1ZbTBiZSdEqy0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeJ0Ih/8vIHpF7+4lPcHrAOhBKIylrZon4YZvFtptil7dkKd30YiZ7juYT+ui9lC1
         VVvemuF2C0PxVzqLOwBP38jRFtCOLUAsENzDleEvBBMlIesu8UEjswrCK7Wiwptuh4
         S2afR3HJ7AYsPq32LgNYJ1U3xFYEkjtUzIv7BDlHJ0j15j4W2jLqzdHalf2tW28X8s
         olPSgMrSSoG7F20x9Up56Syg3p+JkSxoA1xNLbHSywcZLImZBrJ6vQoQnA+Tp5hIvh
         T1C4zHtx+IpbcC1qZaO851r7C4rnNjvqnGiBN9rSjCnOQKulBznA+hMCBLwN9OPQU8
         uObYf4PwasanQ==
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        Tianfei zhang <tianfei.zhang@intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Scott Branden <sbranden@broadcom.com>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v5 3/3] test_firmware: fix the memory leak of the allocated firmware buffer
Date:   Wed, 26 Apr 2023 15:14:43 +0200
Message-Id: <20230426131438.16936-3-mirsad.todorovac@alu.unizg.hr>
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

The following kernel memory leak was noticed after running
tools/testing/selftests/firmware/fw_run_tests.sh:

[root@pc-mtodorov firmware]# cat /sys/kernel/debug/kmemleak
.
.
.
unreferenced object 0xffff955389bc3400 (size 1024):
  comm "test_firmware-0", pid 5451, jiffies 4294944822 (age 65.652s)
  hex dump (first 32 bytes):
    47 48 34 35 36 37 0a 00 00 00 00 00 00 00 00 00  GH4567..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff962f5dec>] slab_post_alloc_hook+0x8c/0x3c0
    [<ffffffff962fcca4>] __kmem_cache_alloc_node+0x184/0x240
    [<ffffffff962704de>] kmalloc_trace+0x2e/0xc0
    [<ffffffff9665b42d>] test_fw_run_batch_request+0x9d/0x180
    [<ffffffff95fd813b>] kthread+0x10b/0x140
    [<ffffffff95e033e9>] ret_from_fork+0x29/0x50
unreferenced object 0xffff9553c334b400 (size 1024):
  comm "test_firmware-1", pid 5452, jiffies 4294944822 (age 65.652s)
  hex dump (first 32 bytes):
    47 48 34 35 36 37 0a 00 00 00 00 00 00 00 00 00  GH4567..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff962f5dec>] slab_post_alloc_hook+0x8c/0x3c0
    [<ffffffff962fcca4>] __kmem_cache_alloc_node+0x184/0x240
    [<ffffffff962704de>] kmalloc_trace+0x2e/0xc0
    [<ffffffff9665b42d>] test_fw_run_batch_request+0x9d/0x180
    [<ffffffff95fd813b>] kthread+0x10b/0x140
    [<ffffffff95e033e9>] ret_from_fork+0x29/0x50
unreferenced object 0xffff9553c334f000 (size 1024):
  comm "test_firmware-2", pid 5453, jiffies 4294944822 (age 65.652s)
  hex dump (first 32 bytes):
    47 48 34 35 36 37 0a 00 00 00 00 00 00 00 00 00  GH4567..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff962f5dec>] slab_post_alloc_hook+0x8c/0x3c0
    [<ffffffff962fcca4>] __kmem_cache_alloc_node+0x184/0x240
    [<ffffffff962704de>] kmalloc_trace+0x2e/0xc0
    [<ffffffff9665b42d>] test_fw_run_batch_request+0x9d/0x180
    [<ffffffff95fd813b>] kthread+0x10b/0x140
    [<ffffffff95e033e9>] ret_from_fork+0x29/0x50
unreferenced object 0xffff9553c3348400 (size 1024):
  comm "test_firmware-3", pid 5454, jiffies 4294944822 (age 65.652s)
  hex dump (first 32 bytes):
    47 48 34 35 36 37 0a 00 00 00 00 00 00 00 00 00  GH4567..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff962f5dec>] slab_post_alloc_hook+0x8c/0x3c0
    [<ffffffff962fcca4>] __kmem_cache_alloc_node+0x184/0x240
    [<ffffffff962704de>] kmalloc_trace+0x2e/0xc0
    [<ffffffff9665b42d>] test_fw_run_batch_request+0x9d/0x180
    [<ffffffff95fd813b>] kthread+0x10b/0x140
    [<ffffffff95e033e9>] ret_from_fork+0x29/0x50
[root@pc-mtodorov firmware]#

Note that the size 1024 corresponds to the size of the test firmware
buffer. The actual number of the buffers leaked is around 70-110,
depending on the test run.

The cause of the leak is the following:

request_partial_firmware_into_buf() and request_firmware_into_buf()
provided firmware buffer isn't released on release_firmware(), we
have allocated it and we are responsible for deallocating it manually.
This is introduced in a number of context where previously only
release_firmware() was called, which was insufficient.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Fixes: 7feebfa487b92 ("test_firmware: add support for request_firmware_into_buf")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russell.h.weight@intel.com>
Cc: Tianfei zhang <tianfei.zhang@intel.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: stable@vger.kernel.org # v5.4
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
---
 lib/test_firmware.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 91b232ed3161..1d7d480b8eeb 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -45,6 +45,7 @@ struct test_batched_req {
 	bool sent;
 	const struct firmware *fw;
 	const char *name;
+	const char *fw_buf;
 	struct completion completion;
 	struct task_struct *task;
 	struct device *dev;
@@ -175,8 +176,14 @@ static void __test_release_all_firmware(void)
 
 	for (i = 0; i < test_fw_config->num_requests; i++) {
 		req = &test_fw_config->reqs[i];
-		if (req->fw)
+		if (req->fw) {
+			if (req->fw_buf) {
+				kfree_const(req->fw_buf);
+				req->fw_buf = NULL;
+			}
 			release_firmware(req->fw);
+			req->fw = NULL;
+		}
 	}
 
 	vfree(test_fw_config->reqs);
@@ -670,6 +677,8 @@ static ssize_t trigger_request_store(struct device *dev,
 
 	mutex_lock(&test_fw_mutex);
 	release_firmware(test_firmware);
+	if (test_fw_config->reqs)
+		__test_release_all_firmware();
 	test_firmware = NULL;
 	rc = request_firmware(&test_firmware, name, dev);
 	if (rc) {
@@ -770,6 +779,8 @@ static ssize_t trigger_async_request_store(struct device *dev,
 	mutex_lock(&test_fw_mutex);
 	release_firmware(test_firmware);
 	test_firmware = NULL;
+	if (test_fw_config->reqs)
+		__test_release_all_firmware();
 	rc = request_firmware_nowait(THIS_MODULE, 1, name, dev, GFP_KERNEL,
 				     NULL, trigger_async_request_cb);
 	if (rc) {
@@ -812,6 +823,8 @@ static ssize_t trigger_custom_fallback_store(struct device *dev,
 
 	mutex_lock(&test_fw_mutex);
 	release_firmware(test_firmware);
+	if (test_fw_config->reqs)
+		__test_release_all_firmware();
 	test_firmware = NULL;
 	rc = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOUEVENT, name,
 				     dev, GFP_KERNEL, NULL,
@@ -874,6 +887,8 @@ static int test_fw_run_batch_request(void *data)
 						 test_fw_config->buf_size);
 		if (!req->fw)
 			kfree(test_buf);
+		else
+			req->fw_buf = test_buf;
 	} else {
 		req->rc = test_fw_config->req_firmware(&req->fw,
 						       req->name,
@@ -934,6 +949,7 @@ static ssize_t trigger_batched_requests_store(struct device *dev,
 		req->fw = NULL;
 		req->idx = i;
 		req->name = test_fw_config->name;
+		req->fw_buf = NULL;
 		req->dev = dev;
 		init_completion(&req->completion);
 		req->task = kthread_run(test_fw_run_batch_request, req,
@@ -1038,6 +1054,7 @@ ssize_t trigger_batched_requests_async_store(struct device *dev,
 	for (i = 0; i < test_fw_config->num_requests; i++) {
 		req = &test_fw_config->reqs[i];
 		req->name = test_fw_config->name;
+		req->fw_buf = NULL;
 		req->fw = NULL;
 		req->idx = i;
 		init_completion(&req->completion);
-- 
2.30.2

