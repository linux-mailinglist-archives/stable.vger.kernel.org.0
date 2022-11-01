Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E69C614914
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiKALcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKALbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B4E1A83F;
        Tue,  1 Nov 2022 04:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C8F5B81CC7;
        Tue,  1 Nov 2022 11:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ABCC433D6;
        Tue,  1 Nov 2022 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302188;
        bh=Zun/SsDVfloOHkAJheKU5bg8mYtiWisWdGLNQhr2Pcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukNOK4Ngb3GaOhiZlxczym+wsGfUD+aPTEMJs85MtAnAvkb7kivR4I0uQ43w7H1Fk
         FLl8mFek0U/46R+o0/EI142DGp2/I0WQmIW+gVHSCLJFboBU79c0pj7eKtU9aujpg8
         zMUCnf3+Kbwnn3S4zCsu6A+1aoVFNZfgGNxVa7lgtUmmFSRpKYEm7AW83bWlgp/Aer
         x+OR/WkGnOvmFdE3Kheup+nrCIK6lOhGNhSkEAERNHwzesN0JLyl9owe8ROUst2w2W
         4WS3aLepdEwDF2l+BSEHthgXOhg7l0qyu/N3mAxBJt4gSKiSaAlP+yL0DpK9jddwSK
         YK9lNSlbzbeUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, kitakar@gmail.com,
        alan@linux.intel.com, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 12/19] media: atomisp: Fix v4l2_fh resource leak on open errors
Date:   Tue,  1 Nov 2022 07:29:12 -0400
Message-Id: <20221101112919.799868-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
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
index 18fff47bd25d..cb61ffb7d3b2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -890,6 +890,7 @@ static int atomisp_open(struct file *file)
 error:
 	hmm_pool_unregister(HMM_POOL_TYPE_DYNAMIC);
 	rt_mutex_unlock(&isp->mutex);
+	v4l2_fh_release(file);
 	return ret;
 }
 
-- 
2.35.1

