Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F052EC11
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfE3DSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731441AbfE3DSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C022246E9;
        Thu, 30 May 2019 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186289;
        bh=9U1o0HPIE8VRUfQyXoUQXWF8IyiPgBYDs61bEhVBOoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iABnq2Z8PT/NK3injLNVNMsPu/+U0C+z8eqwZAqPWuzE3i4CME8fu5eGpNWrL1cky
         6n9MTdikZzkn6RToTS3bsT3WPK5QYx5nB1qGFKZp0ADmtGqmBE7f3g/BCV4sjG0l+V
         gWdfv/X8VV9Y5G4UdIH5bmE2HHyVIgquvln5G3Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/276] thunderbolt: property: Fix a NULL pointer dereference
Date:   Wed, 29 May 2019 20:06:43 -0700
Message-Id: <20190530030540.469639595@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 106204b56f60abf1bead7dceb88f2be3e34433da ]

In case kzalloc fails, the fix releases resources and returns
-ENOMEM to avoid the NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/property.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/property.c
index 67fd0b5551ded..be3f8b592b05b 100644
--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -551,6 +551,11 @@ int tb_property_add_data(struct tb_property_dir *parent, const char *key,
 
 	property->length = size / 4;
 	property->value.data = kzalloc(size, GFP_KERNEL);
+	if (!property->value.data) {
+		kfree(property);
+		return -ENOMEM;
+	}
+
 	memcpy(property->value.data, buf, buflen);
 
 	list_add_tail(&property->list, &parent->properties);
-- 
2.20.1



