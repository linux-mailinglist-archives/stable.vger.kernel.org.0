Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E376E2F218
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfE3ES2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbfE3DPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E7E24547;
        Thu, 30 May 2019 03:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186131;
        bh=Y3eZz0Mm8BdAAV6CkfQUlxz2nBO3lsDVEhIClk1Z1yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyK+ExBvsFclWbqKNJ8cuss/IeqCGJGN5YgCZ6RStL9CSbjHlxTmGmu7TII9ZxT7y
         +0Fap8ikzBIL5e5OxX1iFQZVfmZXo8lo3RBmy2v1qgxh63UXF7TiXu6+0FAyzxLftA
         znRiLBOlgGjG1tzI83bccC20UwigYeOR4KiG5UOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 293/346] media: staging/intel-ipu3: mark PM function as __maybe_unused
Date:   Wed, 29 May 2019 20:06:06 -0700
Message-Id: <20190530030555.706499889@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 948dff7cfa1d7653e7828e7b905863bd24ca5c02 ]

The imgu_rpm_dummy_cb() looks like an API misuse that is explained
in the comment above it. Aside from that, it also causes a warning
when power management support is disabled:

drivers/staging/media/ipu3/ipu3.c:794:12: error: 'imgu_rpm_dummy_cb' defined but not used [-Werror=unused-function]

The warning is at least easy to fix by marking the function as
__maybe_unused.

Fixes: 7fc7af649ca7 ("media: staging/intel-ipu3: Add imgu top level pci device driver")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index d521b3afb8b1a..0b161888ec282 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -792,7 +792,7 @@ static int __maybe_unused imgu_resume(struct device *dev)
  * PCI rpm framework checks the existence of driver rpm callbacks.
  * Place a dummy callback here to avoid rpm going into error state.
  */
-static int imgu_rpm_dummy_cb(struct device *dev)
+static __maybe_unused int imgu_rpm_dummy_cb(struct device *dev)
 {
 	return 0;
 }
-- 
2.20.1



