Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048AF3E57F8
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 12:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhHJKGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 06:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239680AbhHJKEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 06:04:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D474CC0617A1;
        Tue, 10 Aug 2021 03:03:49 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a20so20345100plm.0;
        Tue, 10 Aug 2021 03:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FZv8WUWA7XMtGcmHm3fe2kXxpsT1wGOMqKzhZnOXInc=;
        b=n7riOfASCNRbDihiPbdaEZnz50Wl3IaUDhYTad8G/AQE8zyH1KA/OtdmD8JY6C4SR4
         LU7eUzBaWI1HxZNMiqi98wM2P102T+3tJKdEZrDUVWgySL4URjuKQDeYXtP/Y+Pepo9Q
         eJgtet9sjnlZtgaGMKzGksX0M6FKp3YbojSdJUxiBz+QEzDzk/G8U8fy/QzQEkX/mb34
         CFKoiQKXqlRxYR8apIFoD4SlQiROYb3TH04zMUpwpYlW8JaWPjEp+tY7o5xBYvvdWaH9
         q4Yfy/OSw3j6fQQvaap/HBH5F7S4W0q5WxGatKXU2Ok5zjWIKtMLZ1lpu89AcC4EOjRL
         GnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FZv8WUWA7XMtGcmHm3fe2kXxpsT1wGOMqKzhZnOXInc=;
        b=pgEG3Bqc0jWVoakaAVJDoZHr3K/xergJXhhu37OAyNMA5zm4w7apec7EVAJzN8jwi4
         2eYUotOdhdbv6tsvb0BK2xmUjmKatwDprYb0goXI5hEJFf18imHe8LHgrE2+mkQHeGRE
         oKip2X52USYTs7Hp3gKXUnX0qjiNY0nmcDi/u2pr0hPQwZzzA2r77CVN7DpJsZxp1UDu
         VBaEUEhqzOcSOWNQbGUq5qNLanoYR96cb1AEz4JXoUvGktHFIf/TWQp3RAV9ZjaiCtQ1
         MY5WyfZiTyosdz0zNRNhZYh3hUmrC+CEcqYIpd060SIhPUl3Zl31Q/l8W12P/dbqckNH
         2I3g==
X-Gm-Message-State: AOAM532XvV5pNYY4WzFIcfxU4DZ+JQh6oGH+ziZBwjG7ypugv7yCRp6W
        fbsP0G2GJjDZUCK+ObgVJQo=
X-Google-Smtp-Source: ABdhPJyjHnHQXvLxKdgfLBPWa/XZ3kWSmXNDvd0PaIDD2qxKYcCnx5it80eGot5J+T7kt2ff2O6qEw==
X-Received: by 2002:a17:90a:5888:: with SMTP id j8mr4148681pji.17.1628589829361;
        Tue, 10 Aug 2021 03:03:49 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.217])
        by smtp.gmail.com with ESMTPSA id e13sm22943413pfi.210.2021.08.10.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 03:03:48 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Zhouyang Jia <jiazhouyang09@gmail.com>
Cc:     stable@vger.kernel.org, industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] ipack: tpci200: fix memory leak in the tpci200_register
Date:   Tue, 10 Aug 2021 18:03:19 +0800
Message-Id: <20210810100323.3938492-2-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810100323.3938492-1-mudongliangabcd@gmail.com>
References: <20210810100323.3938492-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error handling code in tpci200_register does not free interface_regs
allocated by ioremap and the current version of error handling code is
problematic.

Fix this by refactoring the error handling code and free interface_regs
when necessary.

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 43986798fd50 ("ipack: add error handling for ioremap_nocache")
Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: revise PATCH 2/3, 3/3, not depending on PATCH 1/3; move the
location change of tpci_unregister into one separate patch;
v2->v3: double check all pci_iounmap api invocations
v3->v4: add a tag - Cc: stable@vger.kernel.org
 drivers/ipack/carriers/tpci200.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 92795a0230ca..cbfdadecb23b 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -254,7 +254,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 2 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_disable_pci;
+		goto err_disable_device;
 	}
 
 	/* Request IO ID INT space (Bar 3) */
@@ -266,7 +266,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 3 !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ip_space;
+		goto err_ip_interface_bar;
 	}
 
 	/* Request MEM8 space (Bar 5) */
@@ -277,7 +277,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 5!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_io_id_int_spaces_bar;
 	}
 
 	/* Request MEM16 space (Bar 4) */
@@ -288,7 +288,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_mem8_space;
+		goto err_mem8_space_bar;
 	}
 
 	/* Map internal tpci200 driver user space */
@@ -302,7 +302,7 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
 		res = -ENOMEM;
-		goto out_release_mem8_space;
+		goto err_mem16_space_bar;
 	}
 
 	/* Initialize lock that protects interface_regs */
@@ -341,18 +341,22 @@ static int tpci200_register(struct tpci200_board *tpci200)
 			"(bn 0x%X, sn 0x%X) unable to register IRQ !",
 			tpci200->info->pdev->bus->number,
 			tpci200->info->pdev->devfn);
-		goto out_release_ioid_int_space;
+		goto err_interface_regs;
 	}
 
 	return 0;
 
-out_release_mem8_space:
+err_interface_regs:
+	pci_iounmap(tpci200->info->pdev, tpci200->info->interface_regs);
+err_mem16_space_bar:
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
+err_mem8_space_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
-out_release_ioid_int_space:
+err_io_id_int_spaces_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
-out_release_ip_space:
+err_ip_interface_bar:
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
-out_disable_pci:
+err_disable_device:
 	pci_disable_device(tpci200->info->pdev);
 	return res;
 }
-- 
2.25.1

