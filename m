Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F433137A3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhBHP2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhBHPXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A82864E8B;
        Mon,  8 Feb 2021 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797278;
        bh=Qvor5QWTMf4BdZqxvn5tpgmKODnqieeGXzsPTF5dfhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYp1DrJdL7MH1etr68RYIzlhWfYmBqXv1E3GhP9sZuFh8anWjtyVenWgzBPg9SYVb
         fHOavEn228E7QDbY0Rqn8S5DoBs8FCCNOiYIHKJt78OlZjhKfbEb9817VL+KGWz3yc
         6WVJjmtPY7OvMYylFVhg4kr7RBZcsbM3nz7FMIlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 053/120] thunderbolt: Fix possible NULL pointer dereference in tb_acpi_add_link()
Date:   Mon,  8 Feb 2021 16:00:40 +0100
Message-Id: <20210208145820.540535458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

commit 4d395c5e74398f664405819330e5a298da37f655 upstream.

When we walk up the device hierarchy in tb_acpi_add_link() make sure we
break the loop if the device has no parent. Otherwise we may crash the
kernel by dereferencing a NULL pointer.

Fixes: b2be2b05cf3b ("thunderbolt: Create device links from ACPI description")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/acpi.c
+++ b/drivers/thunderbolt/acpi.c
@@ -56,7 +56,7 @@ static acpi_status tb_acpi_add_link(acpi
 	 * managed with the xHCI and the SuperSpeed hub so we create the
 	 * link from xHCI instead.
 	 */
-	while (!dev_is_pci(dev))
+	while (dev && !dev_is_pci(dev))
 		dev = dev->parent;
 
 	if (!dev)


