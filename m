Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65DD528F51
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbiEPTyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347749AbiEPTwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EAF427D5;
        Mon, 16 May 2022 12:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FA89B81613;
        Mon, 16 May 2022 19:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A42BC385AA;
        Mon, 16 May 2022 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730460;
        bh=Uj3lyYJac3hTdmS1S+asSpqVLL6qsv9Cd4vdF79qDb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtKgbxAO+AUDHiYyoakvllKHXdC1wkFhdQ20YujpP4QEKtAICxs6I8IvRkGB72w7L
         XP6GX4A5u5se8ahhq57z1Hl8HbAKftnMoHwk09OcBDBGCE57a2PyOjG/EKf+RYBuUU
         mFbfZBJJaVD77pzmKSg7LnOZuykvKdaT7ByywecE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 39/66] firmware_loader: use kernel credentials when reading firmware
Date:   Mon, 16 May 2022 21:36:39 +0200
Message-Id: <20220516193620.544847305@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thiébaud Weksteen <tweek@google.com>

commit 581dd69830341d299b0c097fc366097ab497d679 upstream.

Device drivers may decide to not load firmware when probed to avoid
slowing down the boot process should the firmware filesystem not be
available yet. In this case, the firmware loading request may be done
when a device file associated with the driver is first accessed. The
credentials of the userspace process accessing the device file may be
used to validate access to the firmware files requested by the driver.
Ensure that the kernel assumes the responsibility of reading the
firmware.

This was observed on Android for a graphic driver loading their firmware
when the device file (e.g. /dev/mali0) was first opened by userspace
(i.e. surfaceflinger). The security context of surfaceflinger was used
to validate the access to the firmware file (e.g.
/vendor/firmware/mali.bin).

Previously, Android configurations were not setting up the
firmware_class.path command line argument and were relying on the
userspace fallback mechanism. In this case, the security context of the
userspace daemon (i.e. ueventd) was consistently used to read firmware
files. More Android devices are now found to set firmware_class.path
which gives the kernel the opportunity to read the firmware directly
(via kernel_read_file_from_path_initns). In this scenario, the current
process credentials were used, even if unrelated to the loading of the
firmware file.

Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Cc: <stable@vger.kernel.org> # 5.10
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20220502004952.3970800-1-tweek@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/main.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -793,6 +793,8 @@ _request_firmware(const struct firmware
 		  size_t offset, u32 opt_flags)
 {
 	struct firmware *fw = NULL;
+	struct cred *kern_cred = NULL;
+	const struct cred *old_cred;
 	bool nondirect = false;
 	int ret;
 
@@ -809,6 +811,18 @@ _request_firmware(const struct firmware
 	if (ret <= 0) /* error or already assigned */
 		goto out;
 
+	/*
+	 * We are about to try to access the firmware file. Because we may have been
+	 * called by a driver when serving an unrelated request from userland, we use
+	 * the kernel credentials to read the file.
+	 */
+	kern_cred = prepare_kernel_cred(NULL);
+	if (!kern_cred) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	old_cred = override_creds(kern_cred);
+
 	ret = fw_get_filesystem_firmware(device, fw->priv, "", NULL);
 
 	/* Only full reads can support decompression, platform, and sysfs. */
@@ -834,6 +848,9 @@ _request_firmware(const struct firmware
 	} else
 		ret = assign_fw(fw, device);
 
+	revert_creds(old_cred);
+	put_cred(kern_cred);
+
  out:
 	if (ret < 0) {
 		fw_abort_batch_reqs(fw);


