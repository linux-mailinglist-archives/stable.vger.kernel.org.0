Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A095F1CAC45
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgEHMvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729924AbgEHMvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:51:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E5624953;
        Fri,  8 May 2020 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942302;
        bh=TaSAlepga7wgrNkHC4AjuXBRxZZGYlc93f7nVyV/E2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLKiYcQhLjtybTDspzygiHrc5OjpROF+U+K80uYlF6p3ZP7rw0CxbGPDlc4+DZorp
         QLN8VKqxy2Iam2XXrEnNpnng9Z2rsb8bDkQzH3FqiBAt7nBMtF8GbJsSzQdal/z7xD
         4GZrupnmqmDX25w74mPqBJ1OkrwimNWLzaOTSZWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 23/32] drm/amdgpu: Fix oops when pp_funcs is unset in ACPI event
Date:   Fri,  8 May 2020 14:35:36 +0200
Message-Id: <20200508123038.123624374@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

commit 5932d260a8d85a103bd6c504fbb85ff58b156bf9 upstream.

On ARCTURUS and RENOIR, powerplay is not supported yet.
When plug in or unplug power jack, ACPI event will issue.
Then kernel NULL pointer BUG will be triggered.
Check for NULL pointers before calling.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -71,7 +71,8 @@ void amdgpu_pm_acpi_event_handler(struct
 			adev->pm.ac_power = true;
 		else
 			adev->pm.ac_power = false;
-		if (adev->powerplay.pp_funcs->enable_bapm)
+		if (adev->powerplay.pp_funcs &&
+		    adev->powerplay.pp_funcs->enable_bapm)
 			amdgpu_dpm_enable_bapm(adev, adev->pm.ac_power);
 		mutex_unlock(&adev->pm.mutex);
 	}


