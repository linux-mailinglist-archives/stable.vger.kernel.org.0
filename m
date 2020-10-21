Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D871294C2E
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 14:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411191AbgJUMEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 08:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411173AbgJUMEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 08:04:32 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF09FC0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 05:04:31 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id t9so1737140qtp.9
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 05:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UEwFewh8eG3ajMPqlf00WTkMnYCYn6e8dt1oj38pvXo=;
        b=T/8qdiAnW22kFxUXZ85fcQl9AFJxXjfXeVI9vH+YE9FrFrBjwNInbQIzWJOOSqly35
         uyPP3Q1hWxOpPw6sgzgsIokKzLji48f9/adtwe0t9Nur1zApocV4SMRy2S0xBSqsg8OL
         FzMe0EXWl74M78Gbhzbjo6MFP69yir95DGtKNed5qmFrVJ9Fbq6KAEYLa3l5L/1Wc/ED
         OWmNG5XCNN546o1+Vf3SLrje+9HyaX6wXV8fILl6xBF5PA0P0saLxfP+fgnEswthOrC+
         OUBlWVu/DxutkB/O9Ao0pk1lat+Xq/s+Nllesg3NX6/5b085PBTXI65AVECs2i2b4J7R
         /P1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UEwFewh8eG3ajMPqlf00WTkMnYCYn6e8dt1oj38pvXo=;
        b=ZEuHGSEo+ZLN1ZN16BmBJH1gM9+ZK+wEN22KxXgFAv0/5++A1hDgMAXLkWrleJv+9o
         MQBmZfNM0t+RpMvgKMZ+FGC/dW6q0DWP7NgUBhDtnO9pW+5XActlIJu8utRXQ7DvOS8p
         QaYl5ORP8TyFOKvQKk2elhcS7Q8LANw2HExaUeqxMEJqxOehaliz4lHsRaALKYzRvVAU
         DP0F/JqOw1jxZ1FbGXaXtD9Esx5DIewmM0/k//V0yY8ZZaovyzGL665std34t/jIpfJ+
         5N444ENwzW3SM8xGytsJHPgy4zTIO9BzaCYFHY47QEX91NI1RPK9oc5fbG/RN3vy6mWH
         kFnQ==
X-Gm-Message-State: AOAM532uoJq9maQC6DeECDRfVu1EkAqrH2Z0FDbfFYXHbWFKqI/8tcmI
        6UT+kH3iOTSbSKzLDQZsfS+zJCGlmIc=
X-Google-Smtp-Source: ABdhPJznWM36o+WDdM7AmUR2rdG0hT1k42ioVWvufWOcj0MaeaW+tLQOK08Croha6d0/i9JQae/ooQ==
X-Received: by 2002:ac8:6b8d:: with SMTP id z13mr2726279qts.41.1603281870051;
        Wed, 21 Oct 2020 05:04:30 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:ba27:ebff:fee8:ce27])
        by smtp.gmail.com with ESMTPSA id g11sm1075268qkl.30.2020.10.21.05.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 05:04:29 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     stable@vger.kernel.org
Cc:     David Milburn <dmilburn@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Andryuk <jandryuk@gmail.com>
Subject: [PATCH] nvme-pci: disable the write zeros command for Intel 600P/P3100
Date:   Wed, 21 Oct 2020 08:04:15 -0400
Message-Id: <20201021120415.19722-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

[ Upstream commit ce4cc3133dc72c31bd49ddcf22d0f9eeff47a761 ]

The write zeros command does not work with 4k range.

bash-4.4# ./blkdiscard /dev/nvme0n1p2
bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 2048" /dev/nvme0n1p2
fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 2048) = 0
+++ exited with 0 +++
bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

bash-4.4# ./blkdiscard /dev/nvme0n1p2
bash-4.4# strace -efallocate xfs_io -c "fzero 536895488 4096" /dev/nvme0n1p2
fallocate(3, FALLOC_FL_ZERO_RANGE, 536895488, 4096) = 0
+++ exited with 0 +++
bash-4.4# dd bs=1 if=/dev/nvme0n1p2 skip=536895488 count=512 | hexdump -C
00000000  5c 61 5c b0 96 21 1b 5e  85 0c 07 32 9c 8c eb 3c  |\a\..!.^...2...<|
00000010  4a a2 06 ca 67 15 2d 8e  29 8d a8 a0 7e 46 8c 62  |J...g.-.)...~F.b|
00000020  bb 4c 6c c1 6b f5 ae a5  e4 a9 bc 93 4f 60 ff 7a  |.Ll.k.......O`.z|

Reported-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: David Milburn <dmilburn@redhat.com>
Tested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[ Fix-up for 5.4 since NVME_QUIRK_NO_TEMP_THRESH_CHANGE doesn't exist ]
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>

---
Applicable to 5.4.  NVME_QUIRK_DISABLE_WRITE_ZEROES was introduced in 5.0.
The original commit needs a fix for 5.4 because
NVME_QUIRK_NO_TEMP_THRESH_CHANGE doesn't exist - it looks like it was
added in 5.5.

Observed with mke2fs failures on 5.4 wih Intel 600P.
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index af0b51d1d43e..f5d12bf109c7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3110,7 +3110,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0xf1a5),	/* Intel 600P/P3100 */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
-				NVME_QUIRK_MEDIUM_PRIO_SQ },
+				NVME_QUIRK_MEDIUM_PRIO_SQ |
+				NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0xf1a6),	/* Intel 760p/Pro 7600p */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
-- 
2.26.2

