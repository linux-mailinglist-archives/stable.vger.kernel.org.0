Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEAF5054C2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiDRNKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbiDRNG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:06:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ABF2A24F;
        Mon, 18 Apr 2022 05:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA522B80D9C;
        Mon, 18 Apr 2022 12:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1881EC385A7;
        Mon, 18 Apr 2022 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286037;
        bh=n86Irt6Ow5UK4EEIJgdxAiIlt2DLWJLL3IAaDQDqQ20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRLIaXxod+ifU5i0LPJq9J8x+/+u/5elw0DTW/0jFAP5vTtInDG+u20Q0xc6hA/zk
         DN96RP3uMSmbOna91F6D3RCS8dWz1GOAEc8uL86+wn6oLy72tZVDXXnH6/YFFjW+1z
         TfvkmNKttciFc5ZP/l+SlCSzij1ipz34LD1oSUZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.14 010/284] tpm: fix reference counting for struct tpm_chip
Date:   Mon, 18 Apr 2022 14:09:51 +0200
Message-Id: <20220418121210.989763174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit 7e0438f83dc769465ee663bb5dcf8cc154940712 upstream.

The following sequence of operations results in a refcount warning:

1. Open device /dev/tpmrm.
2. Remove module tpm_tis_spi.
3. Write a TPM command to the file descriptor opened at step 1.

------------[ cut here ]------------
WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
refcount_t: addition on 0; use-after-free.
Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
Hardware name: BCM2711
[<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
[<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
[<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
[<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
[<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
[<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
[<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
[<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
[<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
[<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
Exception stack(0xc226bfa8 to 0xc226bff0)
bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
bfe0: 0000006c beafe648 0001056c b6eb6944
---[ end trace d4b8409def9b8b1f ]---

The reason for this warning is the attempt to get the chip->dev reference
in tpm_common_write() although the reference counter is already zero.

Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
extra reference used to prevent a premature zero counter is never taken,
because the required TPM_CHIP_FLAG_TPM2 flag is never set.

Fix this by moving the TPM 2 character device handling from
tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
in time when the flag has been set in case of TPM2.

Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
already introduced function tpm_devs_release() to release the extra
reference but did not implement the required put on chip->devs that results
in the call of this function.

Fix this by putting chip->devs in tpm_chip_unregister().

Finally move the new implementation for the TPM 2 handling into a new
function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
good case and error cases.

Cc: stable@vger.kernel.org
Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c   |   46 +++++------------------------
 drivers/char/tpm/tpm.h        |    2 +
 drivers/char/tpm/tpm2-space.c |   65 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 38 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -134,14 +134,6 @@ static void tpm_dev_release(struct devic
 	kfree(chip);
 }
 
-static void tpm_devs_release(struct device *dev)
-{
-	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
-
-	/* release the master device reference */
-	put_device(&chip->dev);
-}
-
 /**
  * tpm_class_shutdown() - prepare the TPM device for loss of power.
  * @dev: device to which the chip is associated.
@@ -205,7 +197,6 @@ struct tpm_chip *tpm_chip_alloc(struct d
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
-	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
 	chip->dev.class->shutdown_pre = tpm_class_shutdown;
@@ -213,39 +204,20 @@ struct tpm_chip *tpm_chip_alloc(struct d
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
-	chip->devs.parent = pdev;
-	chip->devs.class = tpmrm_class;
-	chip->devs.release = tpm_devs_release;
-	/* get extra reference on main device to hold on
-	 * behalf of devs.  This holds the chip structure
-	 * while cdevs is in use.  The corresponding put
-	 * is in the tpm_devs_release (TPM2 only)
-	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		get_device(&chip->dev);
-
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	chip->devs.devt =
-		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
-
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
 	if (rc)
 		goto out;
-	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
-	if (rc)
-		goto out;
 
 	if (!pdev)
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
-	cdev_init(&chip->cdevs, &tpmrm_fops);
 	chip->cdev.owner = THIS_MODULE;
-	chip->cdevs.owner = THIS_MODULE;
 
 	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
@@ -257,7 +229,6 @@ struct tpm_chip *tpm_chip_alloc(struct d
 	return chip;
 
 out:
-	put_device(&chip->devs);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -306,14 +277,9 @@ static int tpm_add_char_device(struct tp
 	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = cdev_device_add(&chip->cdevs, &chip->devs);
-		if (rc) {
-			dev_err(&chip->devs,
-				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
-				dev_name(&chip->devs), MAJOR(chip->devs.devt),
-				MINOR(chip->devs.devt), rc);
-			return rc;
-		}
+		rc = tpm_devs_add(chip);
+		if (rc)
+			goto err_del_cdev;
 	}
 
 	/* Make the chip available. */
@@ -321,6 +287,10 @@ static int tpm_add_char_device(struct tp
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
+	return 0;
+
+err_del_cdev:
+	cdev_device_del(&chip->cdev, &chip->dev);
 	return rc;
 }
 
@@ -449,7 +419,7 @@ void tpm_chip_unregister(struct tpm_chip
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		cdev_device_del(&chip->cdevs, &chip->devs);
+		tpm_devs_remove(chip);
 	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -593,4 +593,6 @@ int tpm2_prepare_space(struct tpm_chip *
 		       u8 *cmd);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t *bufsiz);
+int tpm_devs_add(struct tpm_chip *chip);
+void tpm_devs_remove(struct tpm_chip *chip);
 #endif
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -540,3 +540,68 @@ int tpm2_commit_space(struct tpm_chip *c
 
 	return 0;
 }
+
+/*
+ * Put the reference to the main device.
+ */
+static void tpm_devs_release(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
+
+	/* release the master device reference */
+	put_device(&chip->dev);
+}
+
+/*
+ * Remove the device file for exposed TPM spaces and release the device
+ * reference. This may also release the reference to the master device.
+ */
+void tpm_devs_remove(struct tpm_chip *chip)
+{
+	cdev_device_del(&chip->cdevs, &chip->devs);
+	put_device(&chip->devs);
+}
+
+/*
+ * Add a device file to expose TPM spaces. Also take a reference to the
+ * main device.
+ */
+int tpm_devs_add(struct tpm_chip *chip)
+{
+	int rc;
+
+	device_initialize(&chip->devs);
+	chip->devs.parent = chip->dev.parent;
+	chip->devs.class = tpmrm_class;
+
+	/*
+	 * Get extra reference on main device to hold on behalf of devs.
+	 * This holds the chip structure while cdevs is in use. The
+	 * corresponding put is in the tpm_devs_release.
+	 */
+	get_device(&chip->dev);
+	chip->devs.release = tpm_devs_release;
+	chip->devs.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+	cdev_init(&chip->cdevs, &tpmrm_fops);
+	chip->cdevs.owner = THIS_MODULE;
+
+	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
+	if (rc)
+		goto err_put_devs;
+
+	rc = cdev_device_add(&chip->cdevs, &chip->devs);
+	if (rc) {
+		dev_err(&chip->devs,
+			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+		goto err_put_devs;
+	}
+
+	return 0;
+
+err_put_devs:
+	put_device(&chip->devs);
+
+	return rc;
+}


