Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60EC41200B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353956AbhITRsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345867AbhITRqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0EA60E54;
        Mon, 20 Sep 2021 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157820;
        bh=52syZvdNJBYKRLSk5gMqTNEZMjAprRlqMQ6ql/otX5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYb7Iq6BOOmWzgc8ovjUJGl9z3DIQkmLkvWQaK4IPiB8UwnL9RXJBa/aYJugFLaAZ
         RPUj7Kyjfch9tm4cpH6SwlAzSD9KUS+yqowi1QWMIeNWpkoHnE6c/nnIbQWmPNlBuH
         6ct02YSgrU8IgNcoA29uk9U9aDAdGgh8bkfKxHfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/293] platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
Date:   Mon, 20 Sep 2021 18:42:08 +0200
Message-Id: <20210920163938.975233342@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
 drivers/platform/x86/dell-smbios-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell-smbios-wmi.c b/drivers/platform/x86/dell-smbios-wmi.c
index ccccce9b67ef..0ebcf412f6ca 100644
--- a/drivers/platform/x86/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell-smbios-wmi.c
@@ -72,6 +72,7 @@ static int run_smbios_call(struct wmi_device *wdev)
 		if (obj->type == ACPI_TYPE_INTEGER)
 			dev_dbg(&wdev->dev, "SMBIOS call failed: %llu\n",
 				obj->integer.value);
+		kfree(output.pointer);
 		return -EIO;
 	}
 	memcpy(&priv->buf->std, obj->buffer.pointer, obj->buffer.length);
-- 
2.30.2



