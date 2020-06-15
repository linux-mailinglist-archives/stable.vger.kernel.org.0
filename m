Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164C11F982D
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgFONTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729916AbgFONTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:19:43 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E9AC061A0E;
        Mon, 15 Jun 2020 06:19:41 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c12so12459758qtq.11;
        Mon, 15 Jun 2020 06:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y3ar0NlCgHyRvUgHFVw4GwwVEYkMu69FrpNlEgYZaig=;
        b=S/S2vKqaaiMkDzviRm/cegQn34GwLrWUJzwiHO0SG32LaLpY/rNXsqw3qrBJvWE8nz
         vJ3yXdKMkbxGFOnXF0fJTJ3ng+YqmDPBZMVP+BTsB+Zp/2fLBUFulmvBSeR2p95aVSJr
         lPiRIXtpA9L/nyr0fVE/shzaF0Tde6OSPgP2QV+vLGJR4bXoVXxPwRD4vx4aVhzvBaPi
         bQML8PfmRN+AulAeCD43dyushoKncliEd7WaZG8x2g8gtsLZ5/sGnY5G27qsr8JuQVxc
         uuj8QamlfZWw4WJO2jpbfL8RfbaR6EuvKjN3+WhhRHVkm2Nua00pgXNs3bQXjEt5AS2D
         LgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y3ar0NlCgHyRvUgHFVw4GwwVEYkMu69FrpNlEgYZaig=;
        b=C7yYLG4Ykl+2f5+Y8QlPsKHqaMUEWs9PuoiGv+as27jfFhxc7RR9TCYnEl2XR8T9Kh
         FciXfhy4e7cI/7Sa41tXctZRu0hNkUdJrOd1u+MyTjuThX1UfAWTCO+kg2SiD3y9MPeu
         qPdOXUxMzd6gW9EF/3D84DuvHB9WHw68a/P9yZi00LBQe8odQaBbOMhaGsjuYrXRu5F5
         u5bSravj31uVmHaPhUpOpEVX3bAmrQwmCOACxeuYo5OqKLSTrg06isqhCYaNN1h/4qxl
         3pz4/rfZHgIID9pe1ZOdOU1tvDq/5zDM75NTs8H3BwaRm+rnbYUzGc9s4dHImRgfJpPa
         ukHA==
X-Gm-Message-State: AOAM530WjD4z9CytIEFYSjBY1yHFeoE6WJNWF+hxYysKAtdUvBh/5V2m
        Qlv43ScuPr7xk7qQdP6Gq6toE66o
X-Google-Smtp-Source: ABdhPJyWlvPaYg5fM0exV17DKKfaRTgNRErTfbIaQDpsECFpyLk/C8vgs/087jTcN9C+sRmBlCN7vw==
X-Received: by 2002:ac8:7c2:: with SMTP id m2mr15444087qth.282.1592227180849;
        Mon, 15 Jun 2020 06:19:40 -0700 (PDT)
Received: from aford-OptiPlex-7050.logicpd.com ([174.46.170.158])
        by smtp.gmail.com with ESMTPSA id q24sm11520968qkj.103.2020.06.15.06.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 06:19:40 -0700 (PDT)
From:   Adam Ford <aford173@gmail.com>
To:     dri-devel@lists.freedesktop.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/panel-simple: fix connector type for LogicPD Type28 Display
Date:   Mon, 15 Jun 2020 08:19:34 -0500
Message-Id: <20200615131934.12440-1-aford173@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LogicPD Type28 display used by several Logic PD products has not
worked since v5.5.

The connector type for the LogicPD Type 28 display is missing and
drm_panel_bridge_add() requires connector type to be set.

Signed-off-by: Adam Ford <aford173@gmail.com>
CC: stable@vger.kernel.org #v5.5+

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index b6ecd1552132..334e9de5b2c8 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2495,6 +2495,7 @@ static const struct panel_desc logicpd_type_28 = {
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
 		     DRM_BUS_FLAG_SYNC_DRIVE_NEGEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct panel_desc mitsubishi_aa070mc01 = {
-- 
2.17.1

