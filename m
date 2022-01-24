Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641054996EC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358131AbiAXVH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445083AbiAXVCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5457CB8105C;
        Mon, 24 Jan 2022 21:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833F6C340E5;
        Mon, 24 Jan 2022 21:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058124;
        bh=BNw15DMNEo5jqLE6Y6CE4dQGroEOmFccGBlIu/rczgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0j6Mkq5e6oZLt5HEbphiIvxKIUn3YMJZXbLDRjmuT9qvlGviT6xpm+jiyYtlhvnS
         XDZRsxLf7tODqvodb3Np+DsVa+T8cDzUv6w15WNhE/7roKb9uznd+yqT/Fy6hFfonH
         CK0C9GFcAcro4FJjI6uAFEc1oDV6IZ/rPr0GQ0tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0186/1039] media: i2c: Re-order runtime pm initialisation
Date:   Mon, 24 Jan 2022 19:32:55 +0100
Message-Id: <20220124184131.547439151@linuxfoundation.org>
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

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit d2484fbf780762f6f9cc3abb7a07ee42dca2eaa3 ]

The kerneldoc for pm_runtime_set_suspended() says:

"It is not valid to call this function for devices with runtime PM
enabled"

To satisfy that requirement, re-order the calls so that
pm_runtime_enable() is the last one.

Fixes: 11c0d8fdccc5 ("media: i2c: Add support for the OV8865 image sensor")
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2899,8 +2899,8 @@ static int ov8865_probe(struct i2c_clien
 
 	/* Runtime PM */
 
-	pm_runtime_enable(sensor->dev);
 	pm_runtime_set_suspended(sensor->dev);
+	pm_runtime_enable(sensor->dev);
 
 	/* V4L2 subdev register */
 


