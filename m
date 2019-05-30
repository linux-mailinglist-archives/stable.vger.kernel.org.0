Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A722F0FE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfE3EJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730967AbfE3DRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:13 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D18224685;
        Thu, 30 May 2019 03:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186233;
        bh=dgVPfRnNrS9sF00eZQGA8PRNy4LT4oN8ILxqoCCnE5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiDB2jvnI88PhcQeZybE2V2jnnpmm0ORtlJJbXzyV6PDGxvAM1AAnMXxg2QVGNACX
         C+pRnTK89vQpO+5JhIOQCNpfE5TT9KX00kKOCXdNtXCJ+VinmcTQvWsTzermfRmBV3
         EpwbyhYnG6A/L9d+JVaNsFy4413dugPsZ6ePts2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        kbuild test robot <lkp@intel.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/276] staging: vc04_services: handle kzalloc failure
Date:   Wed, 29 May 2019 20:04:57 -0700
Message-Id: <20190530030534.392200891@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a5112277872a56017b777770e2fd4324d4a6c866 ]

The kzalloc here was being used without checking the return - if the
kzalloc fails return VCHIQ_ERROR. The call-site of
vchiq_platform_init_state() vchiq_init_state() was not responding
to an allocation failure so checks for != VCHIQ_SUCCESS
and pass VCHIQ_ERROR up to vchiq_platform_init() which then
will fail with -EINVAL.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Reported-by: kbuild test robot <lkp@intel.com>
Acked-By: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c | 3 +++
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
index e767209030642..c7c8ef67b67fa 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -208,6 +208,9 @@ vchiq_platform_init_state(VCHIQ_STATE_T *state)
 	struct vchiq_2835_state *platform_state;
 
 	state->platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
+	if (!state->platform_state)
+		return VCHIQ_ERROR;
+
 	platform_state = (struct vchiq_2835_state *)state->platform_state;
 
 	platform_state->inited = 1;
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index 7642ced314364..63ce567eb6b75 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -2537,6 +2537,8 @@ vchiq_init_state(VCHIQ_STATE_T *state, VCHIQ_SLOT_ZERO_T *slot_zero,
 	local->debug[DEBUG_ENTRIES] = DEBUG_MAX;
 
 	status = vchiq_platform_init_state(state);
+	if (status != VCHIQ_SUCCESS)
+		return VCHIQ_ERROR;
 
 	/*
 		bring up slot handler thread
-- 
2.20.1



