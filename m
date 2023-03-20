Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492976C1943
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjCTPcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjCTPb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC634331
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F8316154E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800B5C433EF;
        Mon, 20 Mar 2023 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325868;
        bh=WTBquJUY5omJgPWIN2Sl0TNOhyXMIAVEYZNjaxwF7ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaVFDVAw6N5YmiaOPSB8+THNzHw7OFw46jf02lDOyto0DWMDUAlud5Yib0e2pKJb+
         +/myzYF587Pj98eCF3ERQ72aVW7b1rc8dDv0mgklwjgiODvggfs3TTt8lXES2gII4b
         L5a9yzcKXwnI489yZuM9FWYAE2kd+7qaJ6HaVuLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Fagnani <matt.fagnani@bell.net>,
        Vasant Hegde <vasant.hegde@amd.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 159/198] drm/amdgpu: Dont resume IOMMU after incomplete init
Date:   Mon, 20 Mar 2023 15:54:57 +0100
Message-Id: <20230320145514.201960007@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit f3921a9a641483784448fb982b2eb738b383d9b9 upstream.

Check kfd->init_complete in kgd2kfd_iommu_resume, consistent with other
kgd2kfd calls. This should fix IOMMU errors on resume from suspend when
KFD IOMMU initialization failed.

Reported-by: Matt Fagnani <matt.fagnani@bell.net>
Link: https://lore.kernel.org/r/4a3b225c-2ffd-e758-4de1-447375e34cad@bell.net/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217170
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2454
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.info>
Cc: stable@vger.kernel.org
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Matt Fagnani <matt.fagnani@bell.net>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -59,6 +59,7 @@ static int kfd_gtt_sa_init(struct kfd_de
 				unsigned int chunk_size);
 static void kfd_gtt_sa_fini(struct kfd_dev *kfd);
 
+static int kfd_resume_iommu(struct kfd_dev *kfd);
 static int kfd_resume(struct kfd_dev *kfd);
 
 static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
@@ -634,7 +635,7 @@ bool kgd2kfd_device_init(struct kfd_dev
 
 	svm_migrate_init(kfd->adev);
 
-	if (kgd2kfd_resume_iommu(kfd))
+	if (kfd_resume_iommu(kfd))
 		goto device_iommu_error;
 
 	if (kfd_resume(kfd))
@@ -783,6 +784,14 @@ int kgd2kfd_resume(struct kfd_dev *kfd,
 
 int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
 {
+	if (!kfd->init_complete)
+		return 0;
+
+	return kfd_resume_iommu(kfd);
+}
+
+static int kfd_resume_iommu(struct kfd_dev *kfd)
+{
 	int err = 0;
 
 	err = kfd_iommu_resume(kfd);


