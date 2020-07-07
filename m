Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4D217266
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgGGPcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbgGGPVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:21:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8032065D;
        Tue,  7 Jul 2020 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135314;
        bh=aWpgFlCBzK5h+/+1sHuWwv/hk8yVyQu8bgqP+H5I9mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVV6JmpM6MyeIeWsEE276z06XvSXwwRaUkkqz5JmosPcN7btzlFWxlFv0VYUwpK/L
         ptCjcH7QG/Z8Zj3x5giJIgFO1G2X6DzVtRUNSugdATcMXJK9v9g9KNIR5UUiwo4XBR
         luJfBRjR+RGNWmvkL2P/ZHyxq8AZkeBevJ5KVftg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 57/65] drm/amdgpu: use %u rather than %d for sclk/mclk
Date:   Tue,  7 Jul 2020 17:17:36 +0200
Message-Id: <20200707145755.215913352@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit beaf10efca64ac824240838ab1f054dfbefab5e6 upstream.

Large clock values may overflow and show up as negative.

Reported by prOMiNd on IRC.

Acked-by: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -2101,7 +2101,7 @@ static ssize_t amdgpu_hwmon_show_sclk(st
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", sclk * 10 * 1000);
+	return snprintf(buf, PAGE_SIZE, "%u\n", sclk * 10 * 1000);
 }
 
 static ssize_t amdgpu_hwmon_show_sclk_label(struct device *dev,
@@ -2131,7 +2131,7 @@ static ssize_t amdgpu_hwmon_show_mclk(st
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", mclk * 10 * 1000);
+	return snprintf(buf, PAGE_SIZE, "%u\n", mclk * 10 * 1000);
 }
 
 static ssize_t amdgpu_hwmon_show_mclk_label(struct device *dev,


