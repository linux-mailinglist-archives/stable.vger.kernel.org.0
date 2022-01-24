Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3602449A418
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369303AbiAYAB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847663AbiAXXUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:20:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BBEC028C2E;
        Mon, 24 Jan 2022 13:28:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9467E614CB;
        Mon, 24 Jan 2022 21:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6A1C340E4;
        Mon, 24 Jan 2022 21:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059701;
        bh=o+qYG+ML9wHDSqQvfw0/Rdn3tY3nA8lbroLnq/hiesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BHq/qo/ro3EQOt/boZpPTtwPkT4CBYLkreqnoMnKroei294uHGSrQOGiEF40kxFn
         0vJaCQI9TGLyEZDzn9EmuGJk3jUuCiQi6FsriyEm79ODoer0+gVRhvJFBo+JbfwfVd
         uYSyJY8tyigxSG74mavcy6VrwgdoGmPOy7mS5rxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marina Nikolic <Marina.Nikolic@amd.com>,
        Evan Quan <evan.quan@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0705/1039] amdgpu/pm: Make sysfs pm attributes as read-only for VFs
Date:   Mon, 24 Jan 2022 19:41:34 +0100
Message-Id: <20220124184149.031663994@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



