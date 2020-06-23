Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B9E205DFC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgFWUSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388699AbgFWUSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198EC20E65;
        Tue, 23 Jun 2020 20:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943523;
        bh=WVZRPf304XDTXTsxZtHmCIrnuF/WwjdfFiKYz5fD9Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbZqp2vNm+A9qokdd2zHrF/B4c8TCRIOXoVHtC9xwrOthTWe43/eMmfRF6lQErZIu
         VniUMeUwK5895arF/yGLNCTSbTHwh/ln/uu0252PXrJOj4Hqub8ZM1pUNqFRaaNV43
         Pm9azQ7FEGjQgMJAwDB9cF56kwxRyA2b3ZgX5EnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 425/477] drm/amdgpu: Replace invalid device ID with a valid device ID
Date:   Tue, 23 Jun 2020 21:57:02 +0200
Message-Id: <20200623195427.620083004@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Raghuraman <sandy.8925@gmail.com>

commit 790243d3bf78f9830a3b2ffbca1ed0f528295d48 upstream.

Initializes Powertune data for a specific Hawaii card by fixing what
looks like a typo in the code. The device ID 66B1 is not a supported
device ID for this driver, and is not mentioned elsewhere. 67B1 is a
valid device ID, and is a Hawaii Pro GPU.

I have tested on my R9 390 which has device ID 67B1, and it works
fine without problems.

Signed-off-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -239,7 +239,7 @@ static void ci_initialize_power_tune_def
 
 	switch (dev_id) {
 	case 0x67BA:
-	case 0x66B1:
+	case 0x67B1:
 		smu_data->power_tune_defaults = &defaults_hawaii_pro;
 		break;
 	case 0x67B8:


