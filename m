Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC551D41E
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390389AbiEFJV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiEFJV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:21:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DB363519
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 670846209D
        for <stable@vger.kernel.org>; Fri,  6 May 2022 09:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431FC385AA;
        Fri,  6 May 2022 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651828662;
        bh=PlSYBsOVp/lBFqPCX7cxO7lVu3qiG0sLyNlO5fOaB+E=;
        h=Subject:To:From:Date:From;
        b=T/f4RCm2Cm2KA10OKfMXTuouVTio+S3GspiLzyQgpJlsba7CvNw6oTtngAPGlbQ4u
         Z7w92MA35p0G+qcC5PX/f0LST+LOyQFNSpmNrCZqhSQRwdBvbq8rg7eSRKj1pDJzXc
         EM3rBBt336sCRoiNBiec864E7c3lTIMHAvBtaXJY=
Subject: patch "firmware_loader: use kernel credentials when reading firmware" added to driver-core-linus
To:     tweek@google.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        paul@paul-moore.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 May 2022 10:00:32 +0200
Message-ID: <1651824032165231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware_loader: use kernel credentials when reading firmware

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 581dd69830341d299b0c097fc366097ab497d679 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>
Date: Mon, 2 May 2022 10:49:52 +1000
Subject: firmware_loader: use kernel credentials when reading firmware
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
 drivers/base/firmware_loader/main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 94d1789a233e..406a907a4cae 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -735,6 +735,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		  size_t offset, u32 opt_flags)
 {
 	struct firmware *fw = NULL;
+	struct cred *kern_cred = NULL;
+	const struct cred *old_cred;
 	bool nondirect = false;
 	int ret;
 
@@ -751,6 +753,18 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
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
@@ -776,6 +790,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	} else
 		ret = assign_fw(fw, device);
 
+	revert_creds(old_cred);
+	put_cred(kern_cred);
+
  out:
 	if (ret < 0) {
 		fw_abort_batch_reqs(fw);
-- 
2.36.0


