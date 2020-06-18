Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F501FE29C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgFRCDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730539AbgFRBXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9161A21927;
        Thu, 18 Jun 2020 01:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443421;
        bh=0uqhkT2cToTQEOo1hNsvy/f2yrAbp72+49TPOUFtefM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXNmvwzhRwBNKzuGwo1x154JdtkfZ9uEaS04QCysz+qt27wsziJEfiqiOpEzoRM7H
         TxhNcH2YltFcuOZbqvFJO168g64F9xuSCrWOApjlyOqdAG0ntb0FIiDcCK7VaF+byf
         vHbdO4VfvvwcL8Dz7+Lg/jwanivkQrS7Ya+fzlPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 062/172] staging: gasket: Fix mapping refcnt leak when put attribute fails
Date:   Wed, 17 Jun 2020 21:20:28 -0400
Message-Id: <20200618012218.607130-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 57a66838e1494cd881b7f4e110ec685736e8e3ca ]

gasket_sysfs_put_attr() invokes get_mapping(), which returns a reference
of the specified gasket_sysfs_mapping object to "mapping" with increased
refcnt.

When gasket_sysfs_put_attr() returns, local variable "mapping" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one path of
gasket_sysfs_put_attr(). When mapping attribute is unknown, the function
forgets to decrease the refcnt increased by get_mapping(), causing a
refcnt leak.

Fix this issue by calling put_mapping() when put attribute fails due to
unknown attribute.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/1587618895-13660-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gasket/gasket_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gasket/gasket_sysfs.c b/drivers/staging/gasket/gasket_sysfs.c
index fc45f0d13e87..9c982f1c0881 100644
--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -343,6 +343,7 @@ void gasket_sysfs_put_attr(struct device *device,
 
 	dev_err(device, "Unable to put unknown attribute: %s\n",
 		attr->attr.attr.name);
+	put_mapping(mapping);
 }
 EXPORT_SYMBOL(gasket_sysfs_put_attr);
 
-- 
2.25.1

