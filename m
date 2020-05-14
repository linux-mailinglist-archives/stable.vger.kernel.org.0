Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1694D1D3469
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgENPGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 11:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgENPGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 11:06:00 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC45BC061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:06:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x2so1424066pfx.7
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=+ALoD0SbeiLI+IzgTdhs4J2dvfM+RUiVJuNDTkGVn4c=;
        b=uTs9Xx3bEQmQD1Put1KZV14XVGj9ctDJKaYX9xO1j2/d//Zq4idGTL4x6ZyLa0LtQ9
         J+C4qauV7tCEgnNJy0vru1myBXXwl8q8MBPc0kcnPwzVwertBTSC0gvv9W562dTClPds
         qGMLstEgh1WwtTMpjCORWo3r6MGh54cVc1oNvOWA3ElhYaoUmsxuuP+MUiRvziIAHYuJ
         EEyntauMSR6T3YAkHvm6MB9ZC9+gnrZvD2LB8fNdsaq57p3VIS9khALEtW8Ec18Lb5n7
         1Dg0G6+OMpXso8VJB1P8fgstutEKfgB+vABGlBiDZhB7GlXzHn9V8ooH8ncmOCwZxiQq
         /IXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=+ALoD0SbeiLI+IzgTdhs4J2dvfM+RUiVJuNDTkGVn4c=;
        b=c52f7sSmjS2fq+7jzAQmvjSNyHzOdEh0zKQ+n0qTBm2KuMpA81hNEnSM0+NxldY3Ih
         HPAGwbEwJRY7qR5C2CnSbe37UChojlu5q0oko41g5UQUJ/dvKbmlgzIBwZQKu3NxQrU5
         os1d/PNoLn51DCv6C01rxRh4Q+yr3KWU+lf43Ws7aLLTaiEo3amsC06lGzkj4E+kSxOb
         rLtm5g3o+p9yDpqsPGtBlgxD/q83d4Yfn41dTLg+TjuzQDyogm33s6lHeR+ILO7hstHC
         kMc7zF1z9WXVhtd75Vb0sYje42HgsXMexIyOWBW4EuX8GaKIQhRqcw/Jtl9FKf5SEZLN
         QW2w==
X-Gm-Message-State: AOAM5325SAK6hRGhU4EPWnKUdN88cL+txVwRBWE6pdZ0Z1Lw5b+RXAi/
        uePXBlhlT1KYIzJ7dPbX5jNvkSzK
X-Google-Smtp-Source: ABdhPJxcYPYhkNHJbO7IgsxVpwSVlsCimcfNFZavcSDa7+cQTIEd6S76VdpkMsD1LHGEHeWLHpzrtQ==
X-Received: by 2002:a63:fd52:: with SMTP id m18mr4303091pgj.436.1589468756885;
        Thu, 14 May 2020 08:05:56 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q134sm2600102pfc.143.2020.05.14.08.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 May 2020 08:05:55 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4.4..v5.4] scsi: sg: add sg_remove_request in sg_write
Date:   Thu, 14 May 2020 08:05:51 -0700
Message-Id: <20200514150551.240275-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit 83c6f2390040f188cc25b270b4befeb5628c1aee ]

If the __copy_from_user function failed we need to call sg_remove_request
in sg_write.

Link: https://lore.kernel.org/r/610618d9-e983-fd56-ed0f-639428343af7@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[groeck: Backport to v5.4.y and older kernels]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This patch fixes CVE-2020-12770, and the problem it fixes looks like a valid bug.
Please apply to v5.4.y and older kernel branches.

 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 94af30f768f7..9c6bf13daaee 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -689,8 +689,10 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (__copy_from_user(cmnd, buf, cmd_size))
+	if (__copy_from_user(cmnd, buf, cmd_size)) {
+		sg_remove_request(sfp, srp);
 		return -EFAULT;
+	}
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
 	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
-- 
2.17.1

