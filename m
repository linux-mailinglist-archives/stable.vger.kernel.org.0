Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AB911EE10
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfLMW54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 17:57:56 -0500
Received: from mail-yb1-f202.google.com ([209.85.219.202]:51995 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMW54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 17:57:56 -0500
Received: by mail-yb1-f202.google.com with SMTP id m71so1046548ybf.18
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 14:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P50f0ZL2uY1UYmnaU7An9xVTQaVqLWmvMfnLqv/D8hE=;
        b=ZAlVpNgsWpaWUGjJ3ydTk0SJUH+MiUY4V9eh/Ae51P4XpTimSh6/+uEOblVpA503HM
         pFtt6fr8BSUWRLd92ZEVmMW5Yd/G8B2k6bJawctR9Ri5IwkNTpjAQfO2QXXLtcEhjmk6
         T7OWqMDZqydbszrCR6xP5zyfESX4n+yxrqNj8O5Y13ecYiNEChaWjvkOREj1eTbEsigQ
         n6f2IIKKQvJy4Bn/PjO+LoVv+ypMERF60BWJsKr1KJlkqgNtS+tbN3SxbBYRVDkOLzEo
         s9QL8ilqIbc2ewf8hLot8UJFb4UpvK5FA4D2tdAiWwljVObfRYbl1xNqgVFBVcsMj1Ds
         3SgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P50f0ZL2uY1UYmnaU7An9xVTQaVqLWmvMfnLqv/D8hE=;
        b=LrVz8NwwVmszpLhBaZEzkV2MIU2XWXbU/rDb513S1j03fdHoGbfU5OGYKt9rDH+URe
         0paO1HPnTd2Wm3ckYOP8BEhX+l3cvVmsADDflmjJttrkG+7PHiGOF3QZKU4GpbkzXDOx
         hCuEvqLLHR7ZIhC+7E/ea9vOb8U9JuYhX/muq+XJ6Q1U/s6+MgIBItRyTkBQfJKxrmUU
         AoeQ5byjOBCBaHDb+cXya4H5Df4QNV7necgHXdytaEHQquYEkbdU3tS8YoJvSehNXGJ9
         48Sac6lHDhifGM/a1WteLlH8dpRFO41Tm50Abqiat8Oh51W7ZyZ4KwsGnY2twPfjLm/L
         7SLA==
X-Gm-Message-State: APjAAAXQ38NuTS+bHQ6QfMV560yMJ7i3cBS3wosNk4iTBynVq5a0RkYS
        vYuICNnfViFGKGsli8L+YAtg2vIrWnDFEAjGhUhB2Q==
X-Google-Smtp-Source: APXvYqwfK2jbSJ51gES6pxnbB+Jx7JYOcFPHuY8kT3tTVj3kn1raRvsRONiY32BSyPg5RjbqyUNg7SevgSbxc9eN0nB2/A==
X-Received: by 2002:a81:9c14:: with SMTP id m20mr10031332ywa.143.1576277875471;
 Fri, 13 Dec 2019 14:57:55 -0800 (PST)
Date:   Fri, 13 Dec 2019 14:57:48 -0800
Message-Id: <20191213225748.11256-1-matthewgarrett@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH] tpm: Don't make log failures fatal
From:   Matthew Garrett <matthewgarrett@google.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Matthew Garrett <matthewgarrett@google.com>,
        Matthew Garrett <mjg59@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a TPM is in disabled state, it's reasonable for it to have an empty
log. Bailing out of probe in this case means that the PPI interface
isn't available, so there's no way to then enable the TPM from the OS.
In general it seems reasonable to ignore log errors - they shouldn't
itnerfere with any other TPM functionality.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm-chip.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 3d6d394a8661..58073836b555 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -596,9 +596,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	tpm_sysfs_add_device(chip);
 
-	rc = tpm_bios_log_setup(chip);
-	if (rc != 0 && rc != -ENODEV)
-		return rc;
+	tpm_bios_log_setup(chip);
 
 	tpm_add_ppi(chip);
 
-- 
2.24.1.735.g03f4e72817-goog

