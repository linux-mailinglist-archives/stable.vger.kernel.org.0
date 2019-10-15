Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0A6D7781
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfJONeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 09:34:13 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46090 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfJONeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 09:34:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id u22so30524436qtq.13
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 06:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Nz0WF7rDhULEq/M0AKUKx45uq8W8Gj4FTUwaNV+hXus=;
        b=dZg8P97xw4Ha7k5e5UjiQDYUTO9arV5Txu4HfpNVgkYvWdgxpmknBivY2B8jrKwGUj
         n6c65V9yns6Psylgia70jqOxVOpwY+rqyKSv6dLAwjiwuyKCSbnE1mawdcK4e3j2t2vX
         D0ZTp4GEB9j+Yqg2DiQv3seCqO9D/ES5YRjId8ylQD/PmzwEAgx1tPDOAXIdQIIi0+gR
         wMUTsVSzI641MpdVUi04DN3al7G9amZNrrRIXnFmL6r0CZPxgWKikIwkVNXqKcqjutML
         1eOS68LEvTe0aeL2ypCXE7yGbbgNq9TRgMwbP1/KQ348zn7EJtGFvLJyZHYXeHRwaQdV
         OcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Nz0WF7rDhULEq/M0AKUKx45uq8W8Gj4FTUwaNV+hXus=;
        b=pmFtsJKpkMsSSmkWgMFhq6K2JimGuqFBQzVwp0+IXOrrGV74tlxan6HjURUUym9+Rm
         XnJlay3yGqaI2pfRAray7h3ra4KBudYceOTf3LxeJHqClqV0/WIEXZEaOuil5DNRKjai
         vgDI7fWl58vf9P+VSTAC0VgZ2dMwnqFjMn16DFSyFyCPNKaxuu/7I7iV36exIxQxW7j1
         OEtwob2loxp0bN1d9FwKRL/8Pga1HmKyDzOELHSQb91vdUaCCIhZ880mwKy3rpi3xLKr
         pWYMa7OjrGeh7RAJwmZ0pyl0X0CNGBKObQTg6vXGElu1eh0aZWIpakuyDX/ygk5l6+qc
         G1yQ==
X-Gm-Message-State: APjAAAU22JiJ4mN1YkmG5+93rwvSRRp2jhhMiKfJVIoo5NMdCea5M1SY
        SlDRVC2cyzVunuP7GjBkbu3FXvLTcCU=
X-Google-Smtp-Source: APXvYqyiYjsBwQsFex0HWHbPUYkRUXJGPoxzerKUQ9uz2N2e8wWZLEnfyRAMjTTagG20QZdVjibaFw==
X-Received: by 2002:ac8:3158:: with SMTP id h24mr38097651qtb.370.1571146450609;
        Tue, 15 Oct 2019 06:34:10 -0700 (PDT)
Received: from fabio-Latitude-E5450.nxp.com ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id t32sm13478344qtb.64.2019.10.15.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 06:34:09 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     stable@vger.kernel.org
Cc:     robdclark@chromium.org, cphealy@gmail.com, jonathan@marek.ca,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] drm/msm: Use the correct dma_sync calls harder
Date:   Tue, 15 Oct 2019 10:33:53 -0300
Message-Id: <20191015133353.14900-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 9f614197c744002f9968e82c649fdf7fe778e1e7 ]

Looks like the dma_sync calls don't do what we want on armv7 either.
Fixes:

  Unable to handle kernel paging request at virtual address 50001000
  pgd = (ptrval)
  [50001000] *pgd=00000000
  Internal error: Oops: 805 [#1] SMP ARM
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.3.0-rc6-00271-g9f159ae07f07 #4
  Hardware name: Freescale i.MX53 (Device Tree Support)
  PC is at v7_dma_clean_range+0x20/0x38
  LR is at __dma_page_cpu_to_dev+0x28/0x90
  pc : [<c011c76c>]    lr : [<c01181c4>]    psr: 20000013
  sp : d80b5a88  ip : de96c000  fp : d840ce6c
  r10: 00000000  r9 : 00000001  r8 : d843e010
  r7 : 00000000  r6 : 00008000  r5 : ddb6c000  r4 : 00000000
  r3 : 0000003f  r2 : 00000040  r1 : 50008000  r0 : 50001000
  Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
  Control: 10c5387d  Table: 70004019  DAC: 00000051
  Process swapper/0 (pid: 1, stack limit = 0x(ptrval))

Cc: <stable@vger.kernel.org> #5.3
Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 3de433c5b38a ("drm/msm: Use the correct dma_sync calls in msm_gem")
Tested-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/gpu/drm/msm/msm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 8cf6362e64bf..07b5fe0a7e5d 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -50,7 +50,7 @@ static void sync_for_device(struct msm_gem_object *msm_obj)
 {
 	struct device *dev = msm_obj->base.dev->dev;
 
-	if (get_dma_ops(dev)) {
+	if (get_dma_ops(dev) && IS_ENABLED(CONFIG_ARM64)) {
 		dma_sync_sg_for_device(dev, msm_obj->sgt->sgl,
 			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 	} else {
@@ -63,7 +63,7 @@ static void sync_for_cpu(struct msm_gem_object *msm_obj)
 {
 	struct device *dev = msm_obj->base.dev->dev;
 
-	if (get_dma_ops(dev)) {
+	if (get_dma_ops(dev) && IS_ENABLED(CONFIG_ARM64)) {
 		dma_sync_sg_for_cpu(dev, msm_obj->sgt->sgl,
 			msm_obj->sgt->nents, DMA_BIDIRECTIONAL);
 	} else {
-- 
2.17.1

