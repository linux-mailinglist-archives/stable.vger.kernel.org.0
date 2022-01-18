Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F681491632
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiARCdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:33:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42390 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344315AbiARC3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F96B81244;
        Tue, 18 Jan 2022 02:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606A6C36AE3;
        Tue, 18 Jan 2022 02:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472980;
        bh=o+qYG+ML9wHDSqQvfw0/Rdn3tY3nA8lbroLnq/hiesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkdzJxjbGu4pDkLYjH8nvC07Ei5kuKHFfWOoUhYfsYa4sVbv2HLNPhCijROJnc2wN
         w3alVI4upquEH9K9WlWiR4LmhYmPB1fDjvRmWaOjwNd1CXZRWb0BmFzh1YYh2582eF
         7Te4Xdt6ci55sGiEJd87M/+nqA+9tCP4P6unSIp7UhxnYpY1fXeLSgO97cYUmTCcW5
         E7KxEcNTxI1z+895k/e/BQN/9gQ4oSjpC8asrtSRrcUq/N6XVL7fsgiI9WZFP6i0w4
         TgGZbRqYqp3J+ezMeC+Ur5Ltc1xu0z4ra1WOe4fQ5/aacxXpHgAR3by3hYAJC2W69Y
         Ldh7f1JFoKchw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marina Nikolic <Marina.Nikolic@amd.com>,
        Evan Quan <evan.quan@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 188/217] amdgpu/pm: Make sysfs pm attributes as read-only for VFs
Date:   Mon, 17 Jan 2022 21:19:11 -0500
Message-Id: <20220118021940.1942199-188-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marina Nikolic <Marina.Nikolic@amd.com>

[ Upstream commit 11c9cc95f818f0f187e9b579a7f136f532b42445 ]

== Description ==
Setting values of pm attributes through sysfs
should not be allowed in SRIOV mode.
These calls will not be processed by FW anyway,
but error handling on sysfs level should be improved.

== Changes ==
This patch prohibits performing of all set commands
in SRIOV mode on sysfs level.
It offers better error handling as calls that are
not allowed will not be propagated further.

== Test ==
Writing to any sysfs file in passthrough mode will succeed.
Writing to any sysfs file in ONEVF mode will yield error:
"calling process does not have sufficient permission to execute a command".

Signed-off-by: Marina Nikolic <Marina.Nikolic@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 41472ed992530..f8370d54100e8 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2123,6 +2123,12 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		}
 	}
 
+	/* setting should not be allowed from VF */
+	if (amdgpu_sriov_vf(adev)) {
+		dev_attr->attr.mode &= ~S_IWUGO;
+		dev_attr->store = NULL;
+	}
+
 #undef DEVICE_ATTR_IS
 
 	return 0;
-- 
2.34.1

