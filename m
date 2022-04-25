Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A59B50D6A6
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbiDYBks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 21:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbiDYBko (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 21:40:44 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 729D55FA8
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 18:37:40 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgCXDaVd+2ViqYC9AQ--.20151S2;
        Mon, 25 Apr 2022 09:37:36 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linma@zju.edu.cn
Cc:     Duoming Zhou <duoming@zju.edu.cn>, stable@vger.kernel.org
Subject: [PATCH] drivers: nfc: nfcmrvl: fix bugs caused by fw_dnld_over in nfcmrvl driver
Date:   Mon, 25 Apr 2022 09:37:32 +0800
Message-Id: <20220425013732.41836-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgCXDaVd+2ViqYC9AQ--.20151S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4xXw48ZFW7Ww4xCF4rXwb_yoWrGrWUpF
        45KFy5CF1DKF4FqFs8tF4DtFyruFZ3GFy5Cryxtr93Zws0yF4vyw1qy3y5ZrsrZryUJayY
        k3W3A34DGa1vyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEKAVZdtZYdogAis9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The fw_dnld_over() is a reentrant function in nfcmrvl driver, it
could be called by nfcmrvl_fw_dnld_start(), nfcmrvl_nci_recv_frame()
and nfcmrvl_nci_unregister_dev() without synchronization. As a result,
the firmware struct could be deallocated more than once, which leads to
double-free or invalid-free bugs.

The first situation that causes bug is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |  nfcmrvl_nci_unregister_dev
 release_firmware()           |   nfcmrvl_fw_dnld_abort
  kfree(fw) //(1)             |    fw_dnld_over
                              |     release_firmware
  ...                         |      kfree(fw) //(2)
                              |     ...

The second situation that causes bug is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |
 mod_timer                    |
 (wait a time)                |
 fw_dnld_timeout              |  nfcmrvl_nci_unregister_dev
   fw_dnld_over               |   nfcmrvl_fw_dnld_abort
    release_firmware          |    fw_dnld_over
     kfree(fw) //(1)          |     release_firmware
     ...                      |      kfree(fw) //(2)

The third situation that causes bug is shown below:

       (Thread 1)               |       (Thread 2)
nfcmrvl_nci_recv_frame          |
 if(..->fw_download_in_progress)|
  nfcmrvl_fw_dnld_recv_frame    |
   queue_work                   |
                                |
fw_dnld_rx_work                 | nfcmrvl_nci_unregister_dev
 fw_dnld_over                   |  nfcmrvl_fw_dnld_abort
  release_firmware              |   fw_dnld_over
   kfree(fw) //(1)              |    release_firmware
                                |     kfree(fw) //(2)

The firmware struct is deallocated in position (1) and deallocated
in position (2) again.

The crash trace triggered by POC is like below:

[  122.640457] BUG: KASAN: double-free or invalid-free in fw_dnld_over+0x28/0xf0
[  122.640457] Call Trace:
[  122.640457]  <TASK>
[  122.640457]  kfree+0xb0/0x330
[  122.640457]  fw_dnld_over+0x28/0xf0
[  122.640457]  nfcmrvl_nci_unregister_dev+0x61/0x70
[  122.640457]  nci_uart_tty_close+0x87/0xd0
[  122.640457]  tty_ldisc_kill+0x3e/0x80
[  122.640457]  tty_ldisc_hangup+0x1b2/0x2c0
[  122.640457]  __tty_hangup.part.0+0x316/0x520
[  122.640457]  tty_release+0x200/0x670
[  122.640457]  __fput+0x110/0x410
[  122.640457]  task_work_run+0x86/0xd0
[  122.640457]  exit_to_user_mode_prepare+0x1aa/0x1b0
[  122.640457]  syscall_exit_to_user_mode+0x19/0x50
[  122.640457]  do_syscall_64+0x48/0x90
[  122.640457]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  122.640457] RIP: 0033:0x7f68433f6beb

What's more, there are also use-after-free and null-ptr-deref bugs
in nfcmrvl_fw_dnld_start(). If we deallocate firmware struct or
set null to the members of priv->fw_dnld in fw_dnld_over(), then,
we dereference firmware or the members of priv->fw_dnld in
nfcmrvl_fw_dnld_start(), the UAF or NPD bugs will happen.

This patch reorders nfcmrvl_fw_dnld_abort() after nci_unregister_device()
to avoid the double-free, UAF and NPD bugs, as nci_unregister_device()
is well synchronized and won't return if there is a running routine.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Cc: stable@vger.kernel.org
---
 drivers/nfc/nfcmrvl/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 2fcf545012b..1a5284de434 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -183,6 +183,7 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 {
 	struct nci_dev *ndev = priv->ndev;
 
+	nci_unregister_device(ndev);
 	if (priv->ndev->nfc_dev->fw_download_in_progress)
 		nfcmrvl_fw_dnld_abort(priv);
 
@@ -191,7 +192,6 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv)
 	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_free(priv->config.reset_n_io);
 
-	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 	kfree(priv);
 }
-- 
2.17.1

