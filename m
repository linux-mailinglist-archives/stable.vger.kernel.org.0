Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4607C3FA991
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhH2GyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2GyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05E5608FB;
        Sun, 29 Aug 2021 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630219991;
        bh=r3wsHGzXeXJyzXCInjxOUpHyGaBwY3IU5tfft8zRzAg=;
        h=Subject:To:Cc:From:Date:From;
        b=GgU5nbyA2EjBP88djKlOVdLt7K2JefjvX0sZvPR+V00r8eFBjOcepapXx0vImogcc
         a71pdlRDl1XcMEmYWD26yVCxeVu6fxjYMqbf6VyVPZ8ShelYCzuEqvWyCPxZLDUVoc
         WfzcSZjUAI5UOmlNkiCqXxxw/OG9OdVzBJ3dXdfs=
Subject: FAILED: patch "[PATCH] Revert "media: dvb header files: move some headers to" failed to apply to 5.13-stable tree
To:     torvalds@linux-foundation.org, mchehab+huawei@kernel.org,
        smoch@web.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Aug 2021 08:53:05 +0200
Message-ID: <163021998513237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d5ae8d7f85b7f6f6e60f1af8ff4be52b0926fde1 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Aug 2021 09:49:09 -0700
Subject: [PATCH] Revert "media: dvb header files: move some headers to
 staging"

This reverts commit 819fbd3d8ef36c09576c2a0ffea503f5c46e9177.

It turns out that some user-space applications use these uapi header
files, so even though the only user of the interface is an old driver
that was moved to staging, moving the header files causes unnecessary
pain.

Generally, we really don't want user space to use kernel headers
directly (exactly because it causes pain when we re-organize), and
instead copy them as needed.  But these things happen, and the headers
were in the uapi directory, so I guess it's not entirely unreasonable.

Link: https://lore.kernel.org/lkml/4e3e0d40-df4a-94f8-7c2d-85010b0873c4@web.de/
Reported-by: Soeren Moch <smoch@web.de>
Cc: stable@kernel.org  # 5.13
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/staging/media/av7110/av7110.h b/drivers/staging/media/av7110/av7110.h
index b8e8fc8ddbe9..809d938ae166 100644
--- a/drivers/staging/media/av7110/av7110.h
+++ b/drivers/staging/media/av7110/av7110.h
@@ -9,12 +9,11 @@
 #include <linux/input.h>
 #include <linux/time.h>
 
-#include "video.h"
-#include "audio.h"
-#include "osd.h"
-
+#include <linux/dvb/video.h>
+#include <linux/dvb/audio.h>
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/ca.h>
+#include <linux/dvb/osd.h>
 #include <linux/dvb/net.h>
 #include <linux/mutex.h>
 
diff --git a/drivers/staging/media/av7110/audio.h b/include/uapi/linux/dvb/audio.h
similarity index 100%
rename from drivers/staging/media/av7110/audio.h
rename to include/uapi/linux/dvb/audio.h
diff --git a/drivers/staging/media/av7110/osd.h b/include/uapi/linux/dvb/osd.h
similarity index 100%
rename from drivers/staging/media/av7110/osd.h
rename to include/uapi/linux/dvb/osd.h
diff --git a/drivers/staging/media/av7110/video.h b/include/uapi/linux/dvb/video.h
similarity index 100%
rename from drivers/staging/media/av7110/video.h
rename to include/uapi/linux/dvb/video.h

