Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F44126D93
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfLSShx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbfLSShv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C9B20716;
        Thu, 19 Dec 2019 18:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780671;
        bh=5iE0gUff8uiKAoyBOvSGE815pKxZqfHAZqQo7ujxFS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0UOmzShlnrMNAq5jrUo0JtMJz9NP/+ewoiBo553O82is6UztmpKilDRy7reMJNlX
         +a/0by3Lh23Bklw5apE7dU+/XY6zry6pE+6SiPCcxkkUF7Vz+g/RFctK/zdKmppU8t
         4HxyxXBJfs5TycZZOaamjCIX83xRc+LOeObEJO7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 032/162] ACPI: fix acpi_find_child_device() invocation in acpi_preset_companion()
Date:   Thu, 19 Dec 2019 19:32:20 +0100
Message-Id: <20191219183209.704129766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit f8c6d1402b89f22a3647705d63cbd171aa19a77e ]

acpi_find_child_device() accepts boolean not pointer as last argument.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
[ rjw: Subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6a30f1e03aa9e..0bd0a9ad54556 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -75,7 +75,7 @@ static inline bool has_acpi_companion(struct device *dev)
 static inline void acpi_preset_companion(struct device *dev,
 					 struct acpi_device *parent, u64 addr)
 {
-	ACPI_COMPANION_SET(dev, acpi_find_child_device(parent, addr, NULL));
+	ACPI_COMPANION_SET(dev, acpi_find_child_device(parent, addr, false));
 }
 
 static inline const char *acpi_dev_name(struct acpi_device *adev)
-- 
2.20.1



