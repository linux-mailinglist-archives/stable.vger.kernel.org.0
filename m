Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD708FA1C4
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfKMB7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbfKMB7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10662247B;
        Wed, 13 Nov 2019 01:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610355;
        bh=+ugDS3NL4mHHN24G7VTK1jmCHcSW7yZCBs8zU+QAsHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PAhrods90GicdI5HmNtd1bdwteDNfcausMoJLJXtmCtClgLAq0IW2nQboV0nQG82
         oVr79EIdhZjgAndkCzQmEceVe3LzXfWr1eZ39sUoYhhrSOixAGnvV9+GhoFhAKF48f
         AZYjAATptynnlW727TtZAQjKtEBzCRgvgNwJ49Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhong jiang <zhongjiang@huawei.com>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 106/115] misc: cxl: Fix possible null pointer dereference
Date:   Tue, 12 Nov 2019 20:56:13 -0500
Message-Id: <20191113015622.11592-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

[ Upstream commit 3dac3583bf1a61db6aaf31dfd752c677a4400afd ]

It is not safe to dereference an object before a null test. It is
not needed and just remove them. Ftrace can be used instead.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/guest.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/cxl/guest.c b/drivers/misc/cxl/guest.c
index 1a64eb185cfd5..de2ce55395454 100644
--- a/drivers/misc/cxl/guest.c
+++ b/drivers/misc/cxl/guest.c
@@ -1028,8 +1028,6 @@ int cxl_guest_init_afu(struct cxl *adapter, int slice, struct device_node *afu_n
 
 void cxl_guest_remove_afu(struct cxl_afu *afu)
 {
-	pr_devel("in %s - AFU(%d)\n", __func__, afu->slice);
-
 	if (!afu)
 		return;
 
-- 
2.20.1

