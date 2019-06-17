Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C248BDF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFQSYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:24:07 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36824 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfFQSYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:24:07 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so23460950ioh.3;
        Mon, 17 Jun 2019 11:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LNDj/9Uge4rb5LG4sl2oFwkMWYo5QYyd6vgWjHPxMYU=;
        b=qQYXAZfu49iyzDbgqn6cbHpgYcLoIDlv7zGX98wyqWvuIYcHIxug+f4sJAV0e8O4xS
         s2aspucn8QC8QewHtixUcfZtc37sAjg4Air9VWD8cmQdivRugh0avoZmTyk4tvKkEMM+
         uCi9QqhFp1GzZUUoej5+j58BBKCszJrqE9LSTLHE3OQBav6nWg3gvpNEdf7ol3uwnMri
         Ha2g/qaKSkhHN+sklpgoeU6VM0qsdYBK1J0JAG/c0O5TAzucfcxvUH8rWNbS3nvxTQmi
         W45Q9UxajNij0sKKOqw9/RMl+1F/XFB7aUFZk/25qTaw1H1SumUXrt6TCVFXSbtgxEHf
         7PyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LNDj/9Uge4rb5LG4sl2oFwkMWYo5QYyd6vgWjHPxMYU=;
        b=MOomKdaZ4tlHnx2hA8hPuFwByQVapFn7Ii6TIOoSiZimsGehhTK+cHcsUQcm8t5FQV
         hQQuVqxQRVq08wEXY2MpJr2HrdBR9A61y5myHl00mIEIDlnXC2MAt8BjE0hHKdKCt3cM
         uosNvXFWKqu8ZHFnbgR5SSun3d07lidsv+f7451rI17a20Ur8lZ3tmBMbMYlxqwwuucb
         paTnHNCzgr8TvQaWU6wZgcsHCQd7Tuicb1+1c6qnAQZl1+hEeNMRP0enY2FwqQV2gZJA
         hkiAVJFPxYe6cD9TH2HnvWYL0wT3G68Ke661Z4KcMLfa4ANdURaeo/B0YKE/10JYBtiF
         Ohrw==
X-Gm-Message-State: APjAAAX6967Y+DKCtqLGHZwchjy/t01KjCKM6Pw73E25GvNLAqx0IxZ/
        BBVJonACh2IoEQGXV/DnUxA=
X-Google-Smtp-Source: APXvYqzyjNQeJEGdeV6RSpDBxUhnrQBrAbJd9GIEz2zpA9IlQT9KOaNLnUdyRAooNwA/EyrALQpQGw==
X-Received: by 2002:a5d:8e08:: with SMTP id e8mr42656031iod.139.1560795845930;
        Mon, 17 Jun 2019 11:24:05 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id r5sm13961804iom.42.2019.06.17.11.24.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 11:24:05 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Stable <stable@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] firmware: improve LSM/IMA security behaviour
Date:   Mon, 17 Jun 2019 14:23:54 -0400
Message-Id: <20190617182354.10846-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The firmware loader queries if LSM/IMA permits it to load firmware
via the sysfs fallback. Unfortunately, the code does the opposite:
it expressly permits sysfs fw loading if security_kernel_load_data(
LOADING_FIRMWARE) returns -EACCES. This happens because a
zero-on-success return value is cast to a bool that's true on success.

Fix the return value handling so we get the correct behaviour.

Fixes: 6e852651f28e ("firmware: add call to LSM hook before firmware sysfs fallback")
Cc: Stable <stable@vger.kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---
 drivers/base/firmware_loader/fallback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index f962488546b6..103b5d37fa86 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -659,7 +659,7 @@ static bool fw_run_sysfs_fallback(enum fw_opt opt_flags)
 	/* Also permit LSMs and IMA to fail firmware sysfs fallback */
 	ret = security_kernel_load_data(LOADING_FIRMWARE);
 	if (ret < 0)
-		return ret;
+		return false;
 
 	return fw_force_sysfs_fallback(opt_flags);
 }
-- 
2.17.1

