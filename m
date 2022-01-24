Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7815E49A344
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366217AbiAXXwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845359AbiAXXMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4C1C067A48;
        Mon, 24 Jan 2022 13:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DC01B8121C;
        Mon, 24 Jan 2022 21:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D618C340E4;
        Mon, 24 Jan 2022 21:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059151;
        bh=Bb08eC+W8XTdWgECuLhGZ+SpmqB3ZVW7ydcpMUaZC30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSg8q3OUG6lVg8s7ELLLbCffpPlr4oPLEhd0kTMS+/pjmwZQvfvuzyilg04b/5gh5
         3kY/8uHMIyku0PhF6GqqD+BVdpoCu9sUxcLI1g6nzWZPVS8ji0S1cvjfBnkd/L1TEi
         4LiTjre4mRq0prYsZUOzV0jXGhUNqZggiQ7uNJGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0521/1039] cxl/core: Remove cxld_const_init in cxl_decoder_alloc()
Date:   Mon, 24 Jan 2022 19:38:30 +0100
Message-Id: <20220124184142.802001397@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit be185c2988b48db65348d94168c793bdbc8d23c3 ]

Commit 48667f676189 ("cxl/core: Split decoder setup into alloc + add")
aimed to fix a large stack frame warning but from v5 to v6, it
introduced a new instance of the warning due to allocating
cxld_const_init on the stack, which was done due to the use of const on
the nr_target member of the cxl_decoder struct. With ARCH=arm
allmodconfig minus CONFIG_KASAN:

GCC 11.2.0:

drivers/cxl/core/bus.c: In function ‘cxl_decoder_alloc’:
drivers/cxl/core/bus.c:523:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
  523 | }
      | ^
cc1: all warnings being treated as errors

Clang 12.0.1:

drivers/cxl/core/bus.c:486:21: error: stack frame size of 1056 bytes in function 'cxl_decoder_alloc' [-Werror,-Wframe-larger-than=]
struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
                    ^
1 error generated.

Revert that part of the change, which makes the stack frame of
cxl_decoder_alloc() much more reasonable.

Fixes: 48667f676189 ("cxl/core: Split decoder setup into alloc + add")
Link: https://github.com/ClangBuiltLinux/linux/issues/1539
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211210213627.2477370-1-nathan@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/bus.c | 6 ++----
 drivers/cxl/cxl.h      | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
index ebd061d039508..46ce58376580b 100644
--- a/drivers/cxl/core/bus.c
+++ b/drivers/cxl/core/bus.c
@@ -485,9 +485,7 @@ out_unlock:
 
 struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 {
-	struct cxl_decoder *cxld, cxld_const_init = {
-		.nr_targets = nr_targets,
-	};
+	struct cxl_decoder *cxld;
 	struct device *dev;
 	int rc = 0;
 
@@ -497,13 +495,13 @@ struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
 	if (!cxld)
 		return ERR_PTR(-ENOMEM);
-	memcpy(cxld, &cxld_const_init, sizeof(cxld_const_init));
 
 	rc = ida_alloc(&port->decoder_ida, GFP_KERNEL);
 	if (rc < 0)
 		goto err;
 
 	cxld->id = rc;
+	cxld->nr_targets = nr_targets;
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3af704e9b448e..7c2b51746e318 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -191,7 +191,7 @@ struct cxl_decoder {
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
-	const int nr_targets;
+	int nr_targets;
 	struct cxl_dport *target[];
 };
 
-- 
2.34.1



