Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA98CA83D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390652AbfJCQXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390650AbfJCQXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F67A2054F;
        Thu,  3 Oct 2019 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119834;
        bh=6BtUQ4/V1KszXMNqYKGNsb4im93ln/f6XS19k9g+gEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGIoa2+ZrNUBPc3g+EmFSUQeDNfTxmqWOJc3aRpCmnhy3u+LrtkEXEjjGbREhJyEf
         67LwsiKip6bpKDkSpoSQQV32D3glbsVeBEkemhOocMz1B2rwO0HmfxH63zpPFv8TmO
         aocIZeTKHH3e9bqF/Bnfjuz3NXTo0tq8omSkDpBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 211/211] drm/amd/display: Restore backlight brightness after system resume
Date:   Thu,  3 Oct 2019 17:54:37 +0200
Message-Id: <20191003154530.869163725@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
@@ -1462,6 +1462,7 @@ static int amdgpu_dm_backlight_get_brigh
 }
 
 static const struct backlight_ops amdgpu_dm_backlight_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = amdgpu_dm_backlight_get_brightness,
 	.update_status	= amdgpu_dm_backlight_update_status,
 };


