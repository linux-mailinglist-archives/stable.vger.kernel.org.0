Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61CE52181C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbiEJNdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243781AbiEJNcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B652CF2A5;
        Tue, 10 May 2022 06:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1151DB81DA6;
        Tue, 10 May 2022 13:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677F6C385A6;
        Tue, 10 May 2022 13:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188925;
        bh=tUBIoF9N6X0NiJbBCmDtbiWMfzpX2+Dhrt4Z/jqBemM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFXi+tnl5mOV/uP2yeRlbQkNL3HvIK2c0ilH/W0uuB7c8bx5dqGEvdPyYGZrg7APc
         dVKe+zQuLdmXbuPrnXNaYYHlQyQXJ2dH/rMM+CVJmGAhOk9VZmhQiWD+bg7guBDqN/
         2ffXZMpmtb1BNmtvT+tVmOiatHuPHHrBTfjLu/Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 71/88] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
Date:   Tue, 10 May 2022 15:07:56 +0200
Message-Id: <20220510130735.795322640@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit d270453a0d9ec10bb8a802a142fb1b3601a83098 upstream.

There are destructive operations such as nfcmrvl_fw_dnld_abort and
gpio_free in nfcmrvl_nci_unregister_dev. The resources such as firmware,
gpio and so on could be destructed while the upper layer functions such as
nfcmrvl_fw_dnld_start and nfcmrvl_nci_recv_frame is executing, which leads
to double-free, use-after-free and null-ptr-deref bugs.

There are three situations that could lead to double-free bugs.

The first situation is shown below:

   (Thread 1)                 |      (Thread 2)
nfcmrvl_fw_dnld_start         |
 ...                          |  nfcmrvl_nci_unregister_dev
 release_firmware()           |   nfcmrvl_fw_dnld_abort
  kfree(fw) //(1)             |    fw_dnld_over
                              |     release_firmware
  ...                         |      kfree(fw) //(2)
                              |     ...

The second situation is shown below:

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

The third situation is shown below:

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

BUG: KASAN: double-free or invalid-free in fw_dnld_over
Call Trace:
  kfree
  fw_dnld_over
  nfcmrvl_nci_unregister_dev
  nci_uart_tty_close
  tty_ldisc_kill
  tty_ldisc_hangup
  __tty_hangup.part.0
  tty_release
  ...

What's more, there are also use-after-free and null-ptr-deref bugs
in nfcmrvl_fw_dnld_start. If we deallocate firmware struct, gpio or
set null to the members of priv->fw_dnld in nfcmrvl_nci_unregister_dev,
then, we dereference firmware, gpio or the members of priv->fw_dnld in
nfcmrvl_fw_dnld_start, the UAF or NPD bugs will happen.

This patch reorders destructive operations after nci_unregister_device
in order to synchronize between cleanup routine and firmware download
routine.

The nci_unregister_device is well synchronized. If the device is
detaching, the firmware download routine will goto error. If firmware
download routine is executing, nci_unregister_device will wait until
firmware download routine is finished.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nfcmrvl/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -194,6 +194,7 @@ void nfcmrvl_nci_unregister_dev(struct n
 {
 	struct nci_dev *ndev = priv->ndev;
 
+	nci_unregister_device(ndev);
 	if (priv->ndev->nfc_dev->fw_download_in_progress)
 		nfcmrvl_fw_dnld_abort(priv);
 
@@ -202,7 +203,6 @@ void nfcmrvl_nci_unregister_dev(struct n
 	if (gpio_is_valid(priv->config.reset_n_io))
 		gpio_free(priv->config.reset_n_io);
 
-	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 	kfree(priv);
 }


