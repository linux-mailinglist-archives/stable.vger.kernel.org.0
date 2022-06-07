Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABD05416D7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377732AbiFGUyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378540AbiFGUwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B8BA9B5;
        Tue,  7 Jun 2022 11:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B6146160D;
        Tue,  7 Jun 2022 18:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BE9C385A5;
        Tue,  7 Jun 2022 18:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627347;
        bh=wJFVW/I+qZbsg4ltQvCNNL+rG+/iesshOHnsxPxAr4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BI/dfyZ+ahMWT0w3DfouDE6uDjcNpb54Oe0fTTnEs+WOfTlRc/sOyypwMI2Fwv2+m
         t1ZI8qIswZOzWj80jYnb/ryqUPFwfJjNtcVXDryivcjNrS2NXQw6saxgENmYEwvQTP
         3zA8IR7jM8S3j9MBhPu46OpheySqUp/0depzoSUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.17 690/772] drm/nouveau/subdev/bus: Ratelimit logging for fault errors
Date:   Tue,  7 Jun 2022 19:04:42 +0200
Message-Id: <20220607165009.385837474@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 9887bda0c831df0c044d6de147d002e48024fb4a upstream.

There's plenty of ways to fudge the GPU when developing on nouveau by
mistake, some of which can result in nouveau seriously spamming dmesg with
fault errors. This can be somewhat annoying, as it can quickly overrun the
message buffer (or your terminal emulator's buffer) and get rid of actually
useful feedback from the driver. While working on my new atomic only MST
branch, I ran into this issue a couple of times.

So, let's fix this by adding nvkm_error_ratelimited(), and using it to
ratelimit errors from faults. This should be fine for developers, since
it's nearly always only the first few faults that we care about seeing.
Plus, you can turn off rate limiting in the kernel if you really need to.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20220429195350.85620-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/include/nvkm/core/subdev.h |    2 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/gf100.c    |   14 +++++++-------
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv31.c     |    6 +++---
 drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv50.c     |    6 +++---
 4 files changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/nouveau/include/nvkm/core/subdev.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/core/subdev.h
@@ -62,4 +62,6 @@ void nvkm_subdev_intr(struct nvkm_subdev
 #define nvkm_debug(s,f,a...) nvkm_printk((s), DEBUG,   info, f, ##a)
 #define nvkm_trace(s,f,a...) nvkm_printk((s), TRACE,   info, f, ##a)
 #define nvkm_spam(s,f,a...)  nvkm_printk((s),  SPAM,    dbg, f, ##a)
+
+#define nvkm_error_ratelimited(s,f,a...) nvkm_printk((s), ERROR, err_ratelimited, f, ##a)
 #endif
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bus/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bus/gf100.c
@@ -35,13 +35,13 @@ gf100_bus_intr(struct nvkm_bus *bus)
 		u32 addr = nvkm_rd32(device, 0x009084);
 		u32 data = nvkm_rd32(device, 0x009088);
 
-		nvkm_error(subdev,
-			   "MMIO %s of %08x FAULT at %06x [ %s%s%s]\n",
-			   (addr & 0x00000002) ? "write" : "read", data,
-			   (addr & 0x00fffffc),
-			   (stat & 0x00000002) ? "!ENGINE " : "",
-			   (stat & 0x00000004) ? "PRIVRING " : "",
-			   (stat & 0x00000008) ? "TIMEOUT " : "");
+		nvkm_error_ratelimited(subdev,
+				       "MMIO %s of %08x FAULT at %06x [ %s%s%s]\n",
+				       (addr & 0x00000002) ? "write" : "read", data,
+				       (addr & 0x00fffffc),
+				       (stat & 0x00000002) ? "!ENGINE " : "",
+				       (stat & 0x00000004) ? "PRIVRING " : "",
+				       (stat & 0x00000008) ? "TIMEOUT " : "");
 
 		nvkm_wr32(device, 0x009084, 0x00000000);
 		nvkm_wr32(device, 0x001100, (stat & 0x0000000e));
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv31.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv31.c
@@ -45,9 +45,9 @@ nv31_bus_intr(struct nvkm_bus *bus)
 		u32 addr = nvkm_rd32(device, 0x009084);
 		u32 data = nvkm_rd32(device, 0x009088);
 
-		nvkm_error(subdev, "MMIO %s of %08x FAULT at %06x\n",
-			   (addr & 0x00000002) ? "write" : "read", data,
-			   (addr & 0x00fffffc));
+		nvkm_error_ratelimited(subdev, "MMIO %s of %08x FAULT at %06x\n",
+				       (addr & 0x00000002) ? "write" : "read", data,
+				       (addr & 0x00fffffc));
 
 		stat &= ~0x00000008;
 		nvkm_wr32(device, 0x001100, 0x00000008);
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bus/nv50.c
@@ -60,9 +60,9 @@ nv50_bus_intr(struct nvkm_bus *bus)
 		u32 addr = nvkm_rd32(device, 0x009084);
 		u32 data = nvkm_rd32(device, 0x009088);
 
-		nvkm_error(subdev, "MMIO %s of %08x FAULT at %06x\n",
-			   (addr & 0x00000002) ? "write" : "read", data,
-			   (addr & 0x00fffffc));
+		nvkm_error_ratelimited(subdev, "MMIO %s of %08x FAULT at %06x\n",
+				       (addr & 0x00000002) ? "write" : "read", data,
+				       (addr & 0x00fffffc));
 
 		stat &= ~0x00000008;
 		nvkm_wr32(device, 0x001100, 0x00000008);


