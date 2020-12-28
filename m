Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF92E6569
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392698AbgL1QAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387692AbgL1NcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC0822B3A;
        Mon, 28 Dec 2020 13:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162290;
        bh=f9hZGXCsYZuNN04GYxzrb9WQU5QXkjWPkEnk/FNdq48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhMuf/psthppEwD6Ohho/S0mjWreyAdv476AxK5ODSTjSdBLoGzbR3Qhu3L8j75Mr
         f9/4/vDe0d286Mwt0q5qGp9DybyGlZ+TM7aXfRnyQD4GAWezl3Pm8ll3lCsn1Cow2+
         sqshuGCNoEn8mV8yGcc1eDnPD4peFvOyrdj3dm+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 222/346] bus: fsl-mc: fix error return code in fsl_mc_object_allocate()
Date:   Mon, 28 Dec 2020 13:49:01 +0100
Message-Id: <20201228124930.507458827@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 3d70fb03711c37bc64e8e9aea5830f498835f6bf ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 197f4d6a4a00 ("staging: fsl-mc: fsl-mc object allocator driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607068967-31991-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-allocator.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-allocator.c b/drivers/bus/fsl-mc/fsl-mc-allocator.c
index e906ecfe23dd8..9cb0733a03991 100644
--- a/drivers/bus/fsl-mc/fsl-mc-allocator.c
+++ b/drivers/bus/fsl-mc/fsl-mc-allocator.c
@@ -292,8 +292,10 @@ int __must_check fsl_mc_object_allocate(struct fsl_mc_device *mc_dev,
 		goto error;
 
 	mc_adev = resource->data;
-	if (!mc_adev)
+	if (!mc_adev) {
+		error = -EINVAL;
 		goto error;
+	}
 
 	*new_mc_adev = mc_adev;
 	return 0;
-- 
2.27.0



