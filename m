Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968DC3CDAF2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbhGSOkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243734AbhGSOiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0503C61279;
        Mon, 19 Jul 2021 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707867;
        bh=66eDIPDNXhxex7laBEYw79LYbS8PI06ZJ7kL+XA/tT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnmtgLqP9Vb7S8vGpFts3Y4YdOGij/LkeHUf0qXpSbMOCK+n1dVeM8f6b+LrivQ7Q
         rY7MVhzc7rDMsXrwoXse01g8LLRZ9xvoHRe3GkGlcPSLWGnxodVax+l+c7i5IhPu4k
         f1CS2W+n6vom593dJlQ5gYS3Y5MW7pVNIuz8xRi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/315] platform/x86: toshiba_acpi: Fix missing error code in toshiba_acpi_setup_keyboard()
Date:   Mon, 19 Jul 2021 16:49:20 +0200
Message-Id: <20210719144945.190741900@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 28e367127718a9cb85d615a71e152f7acee41bfc ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'error'.

Eliminate the follow smatch warning:

drivers/platform/x86/toshiba_acpi.c:2834 toshiba_acpi_setup_keyboard()
warn: missing error code 'error'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/1622628348-87035-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 25955b4d80b0..61eccbb900e0 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -2861,6 +2861,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 
 	if (!dev->info_supported && !dev->system_event_supported) {
 		pr_warn("No hotkey query interface found\n");
+		error = -EINVAL;
 		goto err_remove_filter;
 	}
 
-- 
2.30.2



