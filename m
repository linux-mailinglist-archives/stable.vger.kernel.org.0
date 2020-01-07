Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCB713313C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgAGU6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgAGU6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 481B9214D8;
        Tue,  7 Jan 2020 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430729;
        bh=lwEvHUEXzrdfe2BpEDw3fbwC/XwmhTPZavN4IoK8g6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AufMfaOGJI4ePatiMUqz9fR9bMzuzBzZ1t1XXH0l/7daiLU6C1XKkJq31YWULYK7Q
         VodxFjvkPerth9+Hd6XShglXgpiv6yIb3WMceo9s8JMgu2kgyfeVxeAJgYvux9MxlP
         Cvg3oYwQ7Y7QTCJ2UMQCLZXSV5yDS+RQSCbBcwtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 072/191] drm/amdgpu/smu: add metrics table lock
Date:   Tue,  7 Jan 2020 21:53:12 +0100
Message-Id: <20200107205336.838469456@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 073d5eef9e043c2b7e3ef12bc6c879b1d248e831 upstream.

This table is used for lots of things, add it's own lock.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/900
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c     |    1 +
 drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -844,6 +844,7 @@ static int smu_sw_init(void *handle)
 	smu->smu_baco.platform_support = false;
 
 	mutex_init(&smu->sensor_lock);
+	mutex_init(&smu->metrics_lock);
 
 	smu->watermarks_bitmap = 0;
 	smu->power_profile_mode = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
--- a/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
@@ -345,6 +345,7 @@ struct smu_context
 	const struct pptable_funcs	*ppt_funcs;
 	struct mutex			mutex;
 	struct mutex			sensor_lock;
+	struct mutex			metrics_lock;
 	uint64_t pool_size;
 
 	struct smu_table_context	smu_table;


