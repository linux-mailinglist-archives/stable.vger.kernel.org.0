Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D352FCEB7
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 20:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNTXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 14:23:37 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38792 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNTXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 14:23:37 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so4959648pfp.5
        for <stable@vger.kernel.org>; Thu, 14 Nov 2019 11:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:from:to:cc:subject:date:mime-version
         :content-transfer-encoding;
        bh=wzCOnp2g5c74yPWIyp7wZK4sxxMOjO7vz0Rib0NxX9M=;
        b=i06/EpMQzrDQkqBXZ46Y8NHt7bKhuduDvVXqDhVm3qe16yR54Bu0p2gw+kD7PkjZhv
         1zxfHNP+6Jshhd2y50gYo6CVJsSbKrSW6nvV++h0ws+ynxg/ClYFlnNYHtsdbvp9/+Dg
         mRtWLqRBLHcOKDWACPkEa2XvriQkNROGlk1ZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date:mime-version
         :content-transfer-encoding;
        bh=wzCOnp2g5c74yPWIyp7wZK4sxxMOjO7vz0Rib0NxX9M=;
        b=HZAL7uliEexFtkgOoN1elapUvjvLcjm0toLNKBzcSvIVvdr1fO6qmfXf2fiEUG0VT1
         vEGXS8vrzPZDOmyVEwzSURlVa23T0Dfs1LAX7AlQYHmpzU4kKAGkvkcyrMSLpHsyXG8A
         rSvKXUgL1SLvSr7SJT3erTf7Z+SHK385StfPy8e9Jk4Enxy2lFrqkP+2kEMDq11/UL0r
         JZ6GmMB0QmPbJTWSQ7oDfRPbU3fAs4MPX/hxUvupxnVct7+ZOwaX68arSvawXouHn/Qg
         pCsm+xseBcRD2BVxwZ+qcIH5WW16vMbpjfsF+DOFH7hhA6LU0gtjfO+WaMaHKz0cO2HE
         CwIg==
X-Gm-Message-State: APjAAAVAcZ3PZtSGEu5kFXUzRAGqiH2/g5RZmCGfsOJL6azXBiHlYqz3
        NnBzEyQdr/7FAhxoTTw2XC43Mw==
X-Google-Smtp-Source: APXvYqy+oUpPXoZIRWArlRx4ZdYnYUcCIxtIMddvBBNC4wEAI61WbcQkAtAGD8T9YHqutiyJpKXFJQ==
X-Received: by 2002:a62:2cd7:: with SMTP id s206mr12742593pfs.106.1573759416886;
        Thu, 14 Nov 2019 11:23:36 -0800 (PST)
Received: from evgreen2.mtv.corp.google.com ([2620:15c:202:201:ffda:7716:9afc:1301])
        by smtp.gmail.com with ESMTPSA id z16sm7463478pge.55.2019.11.14.11.23.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 11:23:36 -0800 (PST)
Message-ID: <5dcda9b8.1c69fb81.74ed1.4e10@mx.google.com>
X-Google-Original-Message-ID: <20191114112213.STABLE 4.14.1.I595ffb495f7a7c9217814c117ce671db8c73ab39@changeid>
From:   Evan Green <evgreen@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Duggan <aduggan@synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Pan Bian <bianpan2016@163.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH STABLE 4.14] Revert "Input: synaptics-rmi4 - avoid processing unknown IRQs"
Date:   Thu, 14 Nov 2019 11:22:59 -0800
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 7b9f7a928255a232012be55cb95db30e963b83a7.

That change should have had a fixes tag for
commit 24d28e4f1271 ("Input: synaptics-rmi4 - convert irq distribution to
irq_domain"). The conversion to irq_domain introduced the issue being
fixed by this commit.

In older kernels the bitmap IRQ accounting is done differently, and
it doesn't suffer from the same issue of calling handle_nested_irq(0).
Keeping this commit on kernels 4.14 and older causes problems with
touchpads due to the different semantics of the IRQ bitmasks.

Signed-off-by: Evan Green <evgreen@chromium.org>
---

This revert is only needed on 4.14 where the driver is not yet
converted to irq_domain and the existing bitmasks work fine.
Upstream, the patch works fine and should not be reverted.

---
 drivers/input/rmi4/rmi_driver.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index bae46816a3b3..997ccae7ee05 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -165,7 +165,7 @@ static int rmi_process_interrupt_requests(struct rmi_device *rmi_dev)
 	}
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_and(data->irq_status, data->irq_status, data->fn_irq_bits,
+	bitmap_and(data->irq_status, data->irq_status, data->current_irq_mask,
 	       data->irq_count);
 	/*
 	 * At this point, irq_status has all bits that are set in the
@@ -412,8 +412,6 @@ static int rmi_driver_set_irq_bits(struct rmi_device *rmi_dev,
 	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
 		    data->num_of_irq_regs);
 
-	bitmap_or(data->fn_irq_bits, data->fn_irq_bits, mask, data->irq_count);
-
 error_unlock:
 	mutex_unlock(&data->irq_mutex);
 	return error;
@@ -427,8 +425,6 @@ static int rmi_driver_clear_irq_bits(struct rmi_device *rmi_dev,
 	struct device *dev = &rmi_dev->dev;
 
 	mutex_lock(&data->irq_mutex);
-	bitmap_andnot(data->fn_irq_bits,
-		      data->fn_irq_bits, mask, data->irq_count);
 	bitmap_andnot(data->new_irq_mask,
 		  data->current_irq_mask, mask, data->irq_count);
 
-- 
2.21.0

