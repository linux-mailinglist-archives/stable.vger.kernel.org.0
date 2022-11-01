Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEC86148B8
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiKAL3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiKAL21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3019E1A056;
        Tue,  1 Nov 2022 04:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2107B81CC1;
        Tue,  1 Nov 2022 11:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E0C433C1;
        Tue,  1 Nov 2022 11:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302089;
        bh=IQWnML7R5rhFY2oavhDQX27l1tZcyVC5nL2ZXOPK5tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t41498uOZCJ/Ax089/oKNvKpllDmE7HDEj7Hdw88iuzsnjVFbIKqfeMSixUi/ONZs
         VxZp6XG0WcBsqD6N59XGp2By5b4lb5sGtBo272w8VcvxHOfUo4HlKgp2BneRdcEfO6
         A0WWu6PResHLKOh7zXqP/RbspNKI5ltYa4t9TnPd3l9cl2SZb3edehff0j9cd0aKtd
         DaOJB+UjlCLKy6VPUqWoiKE1Y6Mp20LBmSUs57+GWpkRRdfi+XH0JvMOKFOXKlMQmu
         skKQ1jxpXPaQyBcACEnnyAfi3SXk84BffZLoxYM1gtJimzZTav1v0XS2/y6UFMMw21
         YqLx5V5S1EreA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        alan@linux.intel.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 18/34] media: atomisp: Fix v4l2_fh resource leak on open errors
Date:   Tue,  1 Nov 2022 07:27:10 -0400
Message-Id: <20221101112726.799368-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5b9853ad1329be49343a608d574eb232ff1273d0 ]

When atomisp_open() fails then it must call v4l2_fh_release() to undo
the results of v4l2_fh_open().

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 77150e4ae144..92cbc0e263e8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -903,6 +903,7 @@ static int atomisp_open(struct file *file)
 	pm_runtime_put(vdev->v4l2_dev->dev);
 error:
 	rt_mutex_unlock(&isp->mutex);
+	v4l2_fh_release(file);
 	return ret;
 }
 
-- 
2.35.1

