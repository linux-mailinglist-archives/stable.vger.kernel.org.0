Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707A33A71C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfFIQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbfFIQq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A91D20833;
        Sun,  9 Jun 2019 16:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098787;
        bh=8Meu+dYFXkLHrYLx5N70A08mc//2OwgdQeTvibI2VBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOb8J8PsGfdrMajjWrecvKwiYsN54sxCuccu1bqlDsNVlYjUnwpxfxzo2cr5tM0kD
         l9R4HEnYQYY0DSV/Nj6Fq6L0ScZEIt2GjqoYk+tXPs5V5ymZZmKP3uwzUfSZ0qDnmJ
         yHcWoBOqOyMhYuRhCa/aJeiTvgylMyoH5Gr8UKxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amber Lin <Amber.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.1 61/70] drm/amdgpu/soc15: skip reset on init
Date:   Sun,  9 Jun 2019 18:42:12 +0200
Message-Id: <20190609164132.590111880@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 5887a59961e2295c5b02f39dbc0ecf9212709b7b upstream.

Not necessary on soc15 and breaks driver reload on server cards.

Acked-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -713,6 +713,11 @@ static bool soc15_need_reset_on_init(str
 {
 	u32 sol_reg;
 
+	/* Just return false for soc15 GPUs.  Reset does not seem to
+	 * be necessary.
+	 */
+	return false;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 


