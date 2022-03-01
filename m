Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08C4C8104
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 03:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiCAC1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 21:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiCAC1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 21:27:12 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02455644E;
        Mon, 28 Feb 2022 18:26:31 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id n15so10061881plf.4;
        Mon, 28 Feb 2022 18:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L3FREw+9d8p+5Wk7Ji+of5Fe7y0W+5wKNfRd0lgtjwg=;
        b=cPvCIa91wAntlUanNM1/m9G+67vqmqUHmZZV+HhLSccn0J8vQDydwc/2m1NdY9udpM
         IB8B9otiQD0zBEd2EE6Ty9kw2TAi6C/WIjzMkP5hMU3WwRIpgqeMohFx4f65fK0+P7uO
         OwIjKN3h1Rugr80ZRBMT+3DPj66ovBwULpcSDR2L1K6iwjLtfsVHQ8SxU7IvTF0Y5I7x
         kiAy9FoDr+14YHZ2sxeOpfe4TsEXGdJnEw0P/aECYSGoMTK1TtLEGmcNozRVOgNlS4HU
         +kfzhvxFxl2YC32f+/GoLAuCKlF828QND1Wd/OtRPwMlo3B0zUOXXI7xtdEoA89nv/et
         tLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L3FREw+9d8p+5Wk7Ji+of5Fe7y0W+5wKNfRd0lgtjwg=;
        b=1+SdUwf8CDiPaF8pUQhQZpTsZ0i0GTu59iubi4h5V5cC7ynNv2GLro7eMFUNoiXIsF
         bdszEhHZIG8JkYIYCRNxeHJmvwrnwmlPBRIV3j7lhkCPPlgFpI489MUBbWoYqUdO5FLh
         4JW010xKN6/FFRSODqfirCYyQdBUlOMHkX4GdaQnhVB/ciYDw8SpNymH18DElH+mYBCU
         goy6nweaEik0N4XmW2/mUfHYVVPxOUV4MtwYp5CrGGqyYlrMvcfdz8yVAG0K+95FqcrP
         uR6HAH5HePDks1r6t9Peiv5NSdgJX3O7oLBNlVdO6Vowt5MZSTTN55OI+VD1kmt8RNcF
         WBXg==
X-Gm-Message-State: AOAM532wQUV445cE2VoSfVUgJBnZimPxpqw9sYA8JsfHW168/fBuY+7O
        41WcvPC+SEMwrSGE6+o1Pkg=
X-Google-Smtp-Source: ABdhPJxfqVfqw+0Rvlae8GQ1nwQ0f5qb0LiOin0GZiezxmtuBeMjNjgS5WZifgO+1yw9oFBB14BcTg==
X-Received: by 2002:a17:902:eaca:b0:14f:fb38:f7b8 with SMTP id p10-20020a170902eaca00b0014ffb38f7b8mr23408710pld.145.1646101590361;
        Mon, 28 Feb 2022 18:26:30 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id 142-20020a621894000000b004dfc714b076sm15417821pfy.11.2022.02.28.18.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 18:26:29 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        balbi@kernel.org, axboe@kernel.dk, mingo@kernel.org,
        jj251510319013@gmail.com, zsm@chromium.org,
        stern@rowland.harvard.edu, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 4.14 2/2] usb: gadget: clear related members when goto fail
Date:   Tue,  1 Mar 2022 10:26:08 +0800
Message-Id: <20220301022608.10950-3-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301022608.10950-1-hbh25y@gmail.com>
References: <20220301022608.10950-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

dev->config and dev->hs_config and dev->dev need to be cleaned if
dev_config fails to avoid UAF.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211231172138.7993-2-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org #4.4+
---
 drivers/usb/gadget/legacy/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index eaad03c0252f..25c8809e0a38 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1875,8 +1875,8 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	value = usb_gadget_probe_driver(&gadgetfs_driver);
 	if (value != 0) {
-		kfree (dev->buf);
-		dev->buf = NULL;
+		spin_lock_irq(&dev->lock);
+		goto fail;
 	} else {
 		/* at this point "good" hardware has for the first time
 		 * let the USB the host see us.  alternatively, if users
@@ -1893,6 +1893,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	return value;
 
 fail:
+	dev->config = NULL;
+	dev->hs_config = NULL;
+	dev->dev = NULL;
 	spin_unlock_irq (&dev->lock);
 	pr_debug ("%s: %s fail %zd, %p\n", shortname, __func__, value, dev);
 	kfree (dev->buf);
-- 
2.25.1

