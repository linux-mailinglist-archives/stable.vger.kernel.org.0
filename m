Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB247359
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 08:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfFPGBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 02:01:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39314 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfFPGBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 02:01:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so3944968pgc.6
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 23:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CEu46Rvw2nkzWr1a8IvBz4EJk7Gd6dh5jqTlESlktHE=;
        b=Unp7bD5hzcSuBORl9RCWEFR2LX1v+o1cFPn12AM6v6L6Pjj5KE1XLaG2vtgr5FELb4
         D8ectUIR+zcpfbzDQ74LZltUgVYoYGC4gOCUqzx6a+O2QAaaMuE29Arjmik0xE2OxZTy
         LxMXofPbDzV1c3Z4cqot/f+NvMDJGZlCrmnOcpnKT4dc0X7y2pzXRBZzIb9LqS4F7dIX
         e3j2Irb2gudP4LWZGFmqepRP+dpV9w8PwtkTNBsBHZwNede5GReRK5V3rVNrmHNK9hzR
         +HjVS20ZZ/z5g8H5jbch1Yp3Pkao2lkHhNcftycPhtuEG/xda6X+udWzvLFLfv8KwhZV
         mBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CEu46Rvw2nkzWr1a8IvBz4EJk7Gd6dh5jqTlESlktHE=;
        b=FcfCaprPJtCC4fU0mnyr6wUFAKkprBk1+UhCJSoWK20Bvsv2+uoApT5JVsB/N7jXpC
         9U4TOaYZKA5EnrL6UhA6c3ueMLSpbc+GvTZGnZ3JGGNx90Vvf5oQi2ehuB+miWjqlatn
         r+jqbZOpSCNNtbEUTTh9CyvFGXlAbumDZes0KrRWksgP5nJPqPqy6ck4Mrzl+uyuuU5d
         Y+/sh5reg1YnpmiGlrVvaEjLGsZRV7f0SQlzva4UsxrQvfD/whe9EFQUbC1AlcAoUd3R
         +0ksnlu235QP+3i34Z9lb5Pn/Qmhd0OIynalQX+OAetoLwwvHAQFZGKAsZCa4UDT1lbT
         qPAQ==
X-Gm-Message-State: APjAAAUQ4k6HWy2HEcZdkkZKEeVutBGNOYmsAVnbgCLbhhTYkLooO2D5
        80T6WClgbe80EaSrGCuozcDF36baurWRoA==
X-Google-Smtp-Source: APXvYqyNkafCHe9rLJOSJozBONMow92U3WwBUHUNxGVb7b9JYAgbt9yWcY3TXBaiBB/eln9eimYHOg==
X-Received: by 2002:aa7:9f1c:: with SMTP id g28mr83720000pfr.81.1560664913502;
        Sat, 15 Jun 2019 23:01:53 -0700 (PDT)
Received: from localhost.localdomain (34.217.225.49.dyn.cust.vf.net.nz. [49.225.217.34])
        by smtp.gmail.com with ESMTPSA id h21sm4194125pgg.75.2019.06.15.23.01.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 23:01:53 -0700 (PDT)
From:   Murray McAllister <murray.mcallister@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-graphics-maintainer@vmware.com, thellstrom@vmware.com,
        murray.mcallister@gmail.com
Subject: [PATCH] Backport commit 5ed7f4b5eca1 ("drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read") to linux-4.9-stable
Date:   Sun, 16 Jun 2019 18:01:19 +1200
Message-Id: <20190616060119.4502-1-murray.mcallister@gmail.com>
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

(The original patch failed to apply cleanly in 4.9-stable
as VMW_DEBUG_USER does not exist here.)

Signed-off-by: Murray McAllister <murray.mcallister@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index c7b53d987f06..ae807436e7fe 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2493,7 +2493,8 @@ static int vmw_cmd_dx_set_shader(struct vmw_private *dev_priv,
 
 	cmd = container_of(header, typeof(*cmd), header);
 
-	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX) {
+	if (cmd->body.type >= SVGA3D_SHADERTYPE_DX10_MAX ||
+	    cmd->body.type < SVGA3D_SHADERTYPE_MIN) {
 		DRM_ERROR("Illegal shader type %u.\n",
 			  (unsigned) cmd->body.type);
 		return -EINVAL;
-- 
2.20.1

