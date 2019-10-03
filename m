Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C053BCA77D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406370AbfJCQxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406319AbfJCQxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364E12054F;
        Thu,  3 Oct 2019 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121598;
        bh=HQOP9k1od1myy85F/717zrw6rreMXAjl50chZ4Mu+Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjPnzPKBmDx15ZojKomeddr+6JedGk8HyBdXSHpJwlHJW+Qx2V8ejPbLch6s8pV+u
         O4jN+KwYQDbZyHEBKWFp50TcYKXxz4xpa5mN8zm0encMmvAq/ywxrT8L7quaUBjlU4
         05ewdEbN+KUjxSzLX7N93VwYdF7+QJM0KPS07pas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 337/344] drm/amd/display: Restore backlight brightness after system resume
Date:   Thu,  3 Oct 2019 17:55:02 +0200
Message-Id: <20191003154611.817558774@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit bb264220d9316f6bd7c1fd84b8da398c93912931 upstream.

Laptops with AMD APU doesn't restore display backlight brightness after
system resume.

This issue started when DC was introduced.

Let's use BL_CORE_SUSPENDRESUME so the backlight core calls
update_status callback after system resume to restore the backlight
level.

Tested on Dell Inspiron 3180 (Stoney Ridge) and Dell Latitude 5495
(Raven Ridge).

Cc: <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2107,6 +2107,7 @@ static int amdgpu_dm_backlight_get_brigh
 }
 
 static const struct backlight_ops amdgpu_dm_backlight_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = amdgpu_dm_backlight_get_brightness,
 	.update_status	= amdgpu_dm_backlight_update_status,
 };


