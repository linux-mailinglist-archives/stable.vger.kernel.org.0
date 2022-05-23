Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05585308A7
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 07:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiEWFZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 01:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiEWFZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 01:25:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A815830
        for <stable@vger.kernel.org>; Sun, 22 May 2022 22:25:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c23-20020a62e817000000b005184501a73aso3565408pfi.4
        for <stable@vger.kernel.org>; Sun, 22 May 2022 22:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=9vg+5HC8sC8pWJmxfpGOjjHe4YUUEnMmVD3h/d9niek=;
        b=NWcr7QThNS372ROv0egq7J1W77EHxthlHlTo9Z7tOLGoDHyncOO+uKfWnT4DOl1jc5
         grx2gc44oxxRbbagnP61/q10EUL2mhgukp5IyRDCYeaAbgZ3r83+f2Zld4GI/hOBoYas
         BifgojTfoeebIEG8UzEiCU0jg5jM4f9xIg83wU9/V+Xpggkndtm71SgponApZWq10SOI
         53evSG2Head7ngWwZEls7sljJPFwni6RikuCvjlKa5nYZxwO6MWtreXFQI1VZ30ZsPxE
         0/0URh/OXWlSh0XIMg6kVb8fB0h8sxPSZIy5U3oGLH4IjAvpWzhCsI1FHahCyYhx9ad5
         5log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=9vg+5HC8sC8pWJmxfpGOjjHe4YUUEnMmVD3h/d9niek=;
        b=4apqIgIBPUkJvXl1vocsjsYM203goJ3jc1cJqJXzwR7Xoz0LHgIwgvdEgyTd1rjfMp
         uKalH/WP08wXSwN9BZ7p9e4KIMOqRa3mvYF5PmgkppCXyJ/oaHr9JxNGUskliaxeSb5O
         R0Q9WNW+iVv2OjR1NTh5iYLwTGFNsybYn/eJSWvMAxp7G9nfrr+MKkoA81KOP/gcubIP
         A7YS4j+aK4EZFyCJKL0/Qfkf9VI7X99d6OG0UIw81xH+LOJfUOHgHlrkWFV80LWqLEb9
         bJjsr3/8Ry9VUtiHMtxKsxdvEjw+nypRSN0aqNmF4SCIZyF1CW1VZfNMfHrjuSWeynmZ
         4xJw==
X-Gm-Message-State: AOAM5300Z9QRt9cU05R/bbgkPis032mu1ZJUgWqKsnJBXRmggHXnXXyR
        3eaEZDtH4ukqdEM1FMiZCU7l1I5JwKRDVvLYMCI/5H4pp9m86/UHxsdHcOXIIjfE5Aelg4JGsVK
        6/54DNW/hfcEXhqmMz8+yyWyP4lhiVLzUf8KLzOz6fKKKMw6VtXulNrAA0NE=
X-Google-Smtp-Source: ABdhPJz+at3lHDOJ4csW1HIS4RQpho1S525mJXpMcgGFj4pDluMbII0ucuUN4LZg9udhbUE1TMjwqBHgww==
X-Received: from tweek-sin.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:2bfd])
 (user=tweek job=sendgmr) by 2002:a17:902:6805:b0:161:8214:c170 with SMTP id
 h5-20020a170902680500b001618214c170mr21889162plk.11.1653283517635; Sun, 22
 May 2022 22:25:17 -0700 (PDT)
Date:   Mon, 23 May 2022 15:24:44 +1000
Message-Id: <20220523052444.2421369-1-tweek@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH] firmware_loader: use kernel credentials when reading firmware
From:   "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>
To:     stable@vger.kernel.org
Cc:     "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
Cc: <stable@vger.kernel.org> # 5.4
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20220502004952.3970800-1-tweek@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/main.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_lo=
ader/main.c
index 4f6b76bd957e..12ab50d29548 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -761,6 +761,8 @@ _request_firmware(const struct firmware **firmware_p, c=
onst char *name,
 		  enum fw_opt opt_flags)
 {
 	struct firmware *fw =3D NULL;
+	struct cred *kern_cred =3D NULL;
+	const struct cred *old_cred;
 	int ret;
=20
 	if (!firmware_p)
@@ -776,6 +778,18 @@ _request_firmware(const struct firmware **firmware_p, =
const char *name,
 	if (ret <=3D 0) /* error or already assigned */
 		goto out;
=20
+	/*
+	 * We are about to try to access the firmware file. Because we may have b=
een
+	 * called by a driver when serving an unrelated request from userland, we=
 use
+	 * the kernel credentials to read the file.
+	 */
+	kern_cred =3D prepare_kernel_cred(NULL);
+	if (!kern_cred) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+	old_cred =3D override_creds(kern_cred);
+
 	ret =3D fw_get_filesystem_firmware(device, fw->priv, "", NULL);
 #ifdef CONFIG_FW_LOADER_COMPRESS
 	if (ret =3D=3D -ENOENT)
@@ -792,6 +806,9 @@ _request_firmware(const struct firmware **firmware_p, c=
onst char *name,
 	} else
 		ret =3D assign_fw(fw, device, opt_flags);
=20
+	revert_creds(old_cred);
+	put_cred(kern_cred);
+
  out:
 	if (ret < 0) {
 		fw_abort_batch_reqs(fw);
--=20
2.36.1.124.g0e6072fb45-goog

