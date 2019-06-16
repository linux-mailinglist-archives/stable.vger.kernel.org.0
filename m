Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A1B47357
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfFPF7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 01:59:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41550 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfFPF7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 01:59:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so3930214pgg.8
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 22:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QqyflqTWpAOYWu0xJ/4QDrmUV7Je5eF+8LkUlJw1th0=;
        b=LuAy9wo356CsAFH2rif/RyxUUUtGcJh9G/thB0XVnOzp0F8KEiIELY3nhLYltawrO/
         RtmZDvhDmLd/+3s2pejfdutLMp5HRUV2iArOsT7k7Rj1DBO18DE8605Bqdce5rj2Uh8+
         6Wi9Y/fRZ/Cfzxu70SBH0uFKfoq+HepEr1fHBzUhwiNx+asmLkhOAsl+c8UYY2EreWu5
         YuvKkS7yzD0h421Ie3kYLUMNkf5YeHi413LriUzubAaxtbeM1G84lDhduHNmrnXyxhSB
         vNriXAtptXR3bfg4Ks1TVq0VxTeNkQstJvPjT2UVyiXhKj+14MIolwMSxHwL1MJOKUP2
         /urQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QqyflqTWpAOYWu0xJ/4QDrmUV7Je5eF+8LkUlJw1th0=;
        b=iANWvw6rqT9yWRkwmoasmRH+WNq1SyJNWgpsvAAtzqJyuciGH22uNf2g3E3zT8Frlw
         XRYQyQyZjKDb4NZfdL2+NgoS2kjy3YnL190V0+PCyHaMHm8t8ZVpZPPGbS9CfBXh3QgF
         gWVJt+c7xGAAeiqMiqkgr9OvLObDt4qppnYvjUD7JLiIjyR3JZA8CwROjbY9abzO1BoC
         am4rg3qm6ZsZg9s4kFieInBouoPU4GVY1nzjZOH7H8uBrvWHBuYgIIRqVkY6WLMkFrjv
         eG0OXl+vQyTfHDQMV2sfEJkwGMwVdlVsJnkmR+Mv1RemLWzdpfHTwHyVqbOHuLIvSp/5
         f1lw==
X-Gm-Message-State: APjAAAUnqaOYLnU2kpFeuhnXQ9frs/AU2aP0GMX0T3Uxf8jNKJ8KluzA
        SlD7oHBScTcjES35sPJ+Q8HHY5D38HUAWw==
X-Google-Smtp-Source: APXvYqzylRagEuf+93CNC8CmOSmgCH3onuYwdLKqaZecq1NEZM+r31qs+UgjjHdMfm4Tk9wD53gAkQ==
X-Received: by 2002:a63:1316:: with SMTP id i22mr44997784pgl.274.1560664752193;
        Sat, 15 Jun 2019 22:59:12 -0700 (PDT)
Received: from localhost.localdomain (34.217.225.49.dyn.cust.vf.net.nz. [49.225.217.34])
        by smtp.gmail.com with ESMTPSA id z14sm8828732pgs.79.2019.06.15.22.59.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 22:59:11 -0700 (PDT)
From:   Murray McAllister <murray.mcallister@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-graphics-maintainer@vmware.com, thellstrom@vmware.com,
        murray.mcallister@gmail.com
Subject: [PATCH] Backport commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read") to linux-5.1-stable
Date:   Sun, 16 Jun 2019 17:57:40 +1200
Message-Id: <20190616055740.4055-1-murray.mcallister@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
vmw_cmd_dx_set_shader() leading to an invalid read") upstream.

Commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in
vmw_cmd_dx_set_shader() leading to an invalid read") resolved
an integer underflow when SVGA_3D_CMD_DX_SET_SHADER was called
with a shader ID of SVGA3D_INVALID_ID, and a shader type of
SVGA3D_SHADERTYPE_INVALID.

(The original patch failed to apply cleanly in 5.1-stable
as VMW_DEBUG_USER does not exist here.)

Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 88b8178d4687..00dc809e0303 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2338,7 +2338,8 @@ static int vmw_cmd_dx_set_shader(struct vmw_private *dev_priv,
 
 	cmd = container_of(header, typeof(*cmd), header);
 
-	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX) {
+	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX ||
+	    cmd->body.type < SVGA3D_SHADERTYPE_MIN) {
 		DRM_ERROR("Illegal shader type %u.\n",
 			  (unsigned) cmd->body.type);
 		return -EINVAL;
-- 
2.20.1

