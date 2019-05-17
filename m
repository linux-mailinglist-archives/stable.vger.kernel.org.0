Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BB8219C2
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfEQO06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 10:26:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43566 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbfEQO06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 10:26:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id i26so8131794qtr.10
        for <stable@vger.kernel.org>; Fri, 17 May 2019 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwbw/p1FQ9WZpF9OwRbP/MyJ0X5N5nXOMniefooZyZE=;
        b=vg4DAV/rf5w+2cPP1BbVKnJQaxOCod/wgOb9yGnmQbj7H3AahQ6RnuA/Aqmwszzc9V
         nbaG6onbkkiUO8FkWqTfOcN8Q+5ADab3cUWTbNZ9PgT5pt53+9wLxxpvL33Xfz7PHzuL
         NYH6GKnq16e3HBr/0E9TAafuq62rvMtvuUbYMcPQh+nGlkRyLKbkd05Y+eywSe0301m7
         5uu982AkrXn6xD7bTrtGQhCYNuLV9k4DuvZwf+UwSq/Qmkvqc6LQipk8SDgYrxSlQhC7
         nCjTmHlxpTx5x0mplhpsAq/GwNWmw3QoVnnFPUAqsv/LkJpgJkDNYoVth4VbgRFo8ZGF
         zmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwbw/p1FQ9WZpF9OwRbP/MyJ0X5N5nXOMniefooZyZE=;
        b=U6McysgphifRiIEyFGKfQrfM/PKQzreNi9mhZfdpdGJP+us0RKhvjqzS0oEkcn3/yZ
         q37Yrr2LHdMwhqiiR13Auv3O9NC4kP8w16QstwSy+m4TU9ua+8AmdLjanSzTE6+Hm4z2
         4iLwdRzXvHlFMr10/V3cymj7KQ1fRhjxkmphxZ2v3a2zu8HY75jRgxm358rSGiiwH2Q5
         1cqbUljVynliWDzd7i+FSy9Jueup7GrZ32s+JyBWFHemituVzZzvoJ2HruhBj58mpTUA
         JdlNopr9I5jySEX88PeCNsKuXMAyEYJhbThE3pieUbWN75xjyRWi45oR473n21WRYKYA
         Iyhg==
X-Gm-Message-State: APjAAAWc3tgVP53yF96M6PhoqHZp76jDWvLWMx3MptGZt0Vz9BMdFqXM
        xe2FDGVP0e7WNrO5dhjj+0g=
X-Google-Smtp-Source: APXvYqyuhgEwWqKhPi4N7jgCM9xkrA/eTLlvLZatnGZxdBPCLjKtwPixaDihNPmAHsyAoMsUhm8P2w==
X-Received: by 2002:ac8:30f3:: with SMTP id w48mr47053075qta.90.1558103217571;
        Fri, 17 May 2019 07:26:57 -0700 (PDT)
Received: from localhost.localdomain ([71.219.84.143])
        by smtp.gmail.com with ESMTPSA id r129sm4129209qkb.9.2019.05.17.07.26.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 17 May 2019 07:26:56 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org
Subject: [PATCH] drm/amdgpu/soc15: skip reset on init
Date:   Fri, 17 May 2019 09:26:47 -0500
Message-Id: <20190517142647.26034-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not necessary on soc15 and breaks driver reload on server cards.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 32dc5a128249..78bd4fc07bab 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -761,6 +761,11 @@ static bool soc15_need_reset_on_init(struct amdgpu_device *adev)
 {
 	u32 sol_reg;
 
+	/* Just return false for soc15 GPUs.  Reset does not seem to
+	 * be necessary.
+	 */
+	return false;
+
 	if (adev->flags & AMD_IS_APU)
 		return false;
 
-- 
2.20.1

