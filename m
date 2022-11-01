Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31A461493C
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiKALfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiKALez (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:34:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E7C1CB01;
        Tue,  1 Nov 2022 04:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36FE8B81CC1;
        Tue,  1 Nov 2022 11:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76EDC433C1;
        Tue,  1 Nov 2022 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302235;
        bh=cmNTbBy0ITeyQAOWKJ1WhJquHtMEaGIfAStDm/zXi/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQW6zXZU2NQLpgsgZy4nmfayTOEIqFoK6ZudxvFuQcTkEL5ivtQK91xyLsniUwOdX
         owMnwV95PJfTUv/efCrn3tQRI1DKx/HhN7lTe5BANfRcfdn+73vgvUStLh5JUMReDE
         IU04oMYMdh3Q2XQtIzygF8GsGS7Ep4OraPLfdnCj1Fq3U2J5XK/LmzPuUiOH+y/iVQ
         K+dE/NRnuyx+YMdwDIV98utJuQGhh3Z1gOALoTacrfqjlZgjJr+8aqOIoZesRaCrrO
         1FkT2bro2GxCF00ypBi/Ka5PfPgSzpfRDPJgg/qYXupDNqni+dTrlE3H11aDpfCxra
         PmyU2scCz6E/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        alan@linux.intel.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 08/14] media: atomisp: Fix v4l2_fh resource leak on open errors
Date:   Tue,  1 Nov 2022 07:30:04 -0400
Message-Id: <20221101113012.800271-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113012.800271-1-sashal@kernel.org>
References: <20221101113012.800271-1-sashal@kernel.org>
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
index b751df31cc24..ccf398b42520 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -890,6 +890,7 @@ static int atomisp_open(struct file *file)
 	hmm_pool_unregister(HMM_POOL_TYPE_DYNAMIC);
 	pm_runtime_put(vdev->v4l2_dev->dev);
 	rt_mutex_unlock(&isp->mutex);
+	v4l2_fh_release(file);
 	return ret;
 }
 
-- 
2.35.1

