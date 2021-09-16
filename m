Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D348840E2AF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbhIPQlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242842AbhIPQhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C271861425;
        Thu, 16 Sep 2021 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809347;
        bh=j04BCEHtGVhSUxIRHf3111GH6/tzw6YkuSc2gPg4M+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4a42AdDnR9QKPYKd0sZPoxEqXbETFOeVQuh0zDcch1o++GHag0It+625gh4pEX5P
         UkyO1OadubldWh+nshBfjg/uyP/3W1SsruXEp8QGwO/81Dzije5klbFxO9/RL3Hf0c
         8gX59jkqpDUuY3tZQTr0UgfN+2dNyq4NzTmvphOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 122/380] platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
Date:   Thu, 16 Sep 2021 17:57:59 +0200
Message-Id: <20210916155808.198418822@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0487d4fc42d7f31a56cfd9e2237f9ebd889e6112 ]

As pointed out be Kees Cook if we return -EIO because the
obj->type != ACPI_TYPE_BUFFER, then we must kfree the
output buffer before the return.

Fixes: 1a258e670434 ("platform/x86: dell-smbios-wmi: Add new WMI dispatcher driver")
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210826140822.71198-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-smbios-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell/dell-smbios-wmi.c b/drivers/platform/x86/dell/dell-smbios-wmi.c
index 33f823772733..8e761991455a 100644
--- a/drivers/platform/x86/dell/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell/dell-smbios-wmi.c
@@ -69,6 +69,7 @@ static int run_smbios_call(struct wmi_device *wdev)
 		if (obj->type == ACPI_TYPE_INTEGER)
 			dev_dbg(&wdev->dev, "SMBIOS call failed: %llu\n",
 				obj->integer.value);
+		kfree(output.pointer);
 		return -EIO;
 	}
 	memcpy(&priv->buf->std, obj->buffer.pointer, obj->buffer.length);
-- 
2.30.2



