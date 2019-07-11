Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79E765B8D
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbfGKQ3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 12:29:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41126 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbfGKQ32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 12:29:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id q4so3187263pgj.8
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 09:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cvu3lP4uYGQ0nzTJkCmI3lypOqpPvgnq8xhQZDKGwQ=;
        b=QRHANFv3oWTVZzIwwbHZJ+G2G4uGVCd81kkae1vUvDdfh0Z59tW9LCC3oPbUm1+6w1
         s9yt+T2pO64KQYCgFLYrPuq5XcUyc3eh22Ks0tkceEyUTmLY0kzDkSHqpvOSQAKW5VVB
         5paq3pRo21kz7QIpEDCeY0LyRoV/sxazA/tko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cvu3lP4uYGQ0nzTJkCmI3lypOqpPvgnq8xhQZDKGwQ=;
        b=cPtzRO15qZir0v0E7plEexGPy6/7biq8AmLlLueTEMrqB6AJ4LtU7Ffo/f1ZOqY+5a
         b3L+JYnzboFWzjY+47YfGomfPCH8UiuK20T/a1nnPO/ohPrdlPu7hODRj1aqA1f6Y2sm
         hQq7gsjCLCaMWOfGCX8Tu72dUw1eZ5Ev+/16xqltpXKt1R4qBqiyk1TDuYJ6wgzhC/9G
         ROYa0/VitzfKgxABY8foHgah7c2MYGZ3ejkYoT9MLaGe8nU107tygwqpi2UGJXwBcOUD
         CQ707IqTweRRv58Mm4Ot9tXF6sPBbXor+cOhdbVBEoPN6FtF9e14efFvezbP2H7siLII
         g9Dg==
X-Gm-Message-State: APjAAAVBoiEgo3z0koH5nOgFP621fIBZpLguY0XSMo3wN1B+fIrhxICC
        WL75zupHJs9pWjtkTVm/p+L/uDSSxJU=
X-Google-Smtp-Source: APXvYqxas7q8ZzI8Hp7bOoO1Sdw4IufzVXuoHWliNFro0YM4+XyheGLisLQYJ2sSMb//6VjjushIpw==
X-Received: by 2002:a17:90b:8e:: with SMTP id bb14mr5861467pjb.19.1562862567357;
        Thu, 11 Jul 2019 09:29:27 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id b6sm5854073pgq.26.2019.07.11.09.29.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 09:29:26 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     stable@vger.kernel.org
Cc:     groeck@chromium.org, gregkh@linuxfoundation.org,
        sukhomlinov@google.com, jarkko.sakkinen@linux.intel.com,
        Douglas Anderson <dianders@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org
Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations
Date:   Thu, 11 Jul 2019 09:29:19 -0700
Message-Id: <20190711162919.23813-1-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Sukhomlinov <sukhomlinov@google.com>

commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream.

TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
future TPM operations. TPM 1.2 behavior was different, future TPM
operations weren't disabled, causing rare issues. This patch ensures
that future TPM operations are disabled.

Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
Cc: stable@vger.kernel.org
Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
[dianders: resolved merge conflicts with mainline]
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
This is the backport of the patch referenced above to 4.19 as was done
in Chrome OS.  See <https://crrev.com/c/1495114> for details.  It
presumably applies to some older kernels.  NOTE that the problem
itself has existed for a long time, but continuing to backport this
exact solution to super old kernels is out of scope for me.  For those
truly interested feel free to reference the past discussion [1].

Reason for backport: mainline has commit a3fbfae82b4c ("tpm: take TPM
chip power gating out of tpm_transmit()") and commit 719b7d81f204
("tpm: introduce tpm_chip_start() and tpm_chip_stop()") and it didn't
seem like a good idea to backport 17 patches to avoid the conflict.

[1] https://lkml.kernel.org/r/CAD=FV=UoSV9LKOTMuXKRfgFir+7_qPkuhSLN6XJEKPiRPuJJwg@mail.gmail.com

 drivers/char/tpm/tpm-chip.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 46caadca916a..f784b6fd93b4 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -187,12 +187,11 @@ static int tpm_class_shutdown(struct device *dev)
 {
 	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		down_write(&chip->ops_sem);
+	down_write(&chip->ops_sem);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
-		chip->ops = NULL;
-		up_write(&chip->ops_sem);
-	}
+	chip->ops = NULL;
+	up_write(&chip->ops_sem);
 
 	return 0;
 }
-- 
2.22.0.410.gd8fdbe21b5-goog

