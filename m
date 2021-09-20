Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE65412180
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358239AbhITSGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357518AbhITSE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE35B61A04;
        Mon, 20 Sep 2021 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158228;
        bh=jYykw5DaYBpv84no3hzLl5H8/qPz6zA5Xu9ir2aKTc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvvgZ6F/UccMr50T3v1s6D8cwJyCHjpdVg7fggPNdVNPwFR+PHygvDO3ZSlUDJRn/
         wRlAiNirLpWWwTTiX0XMAHaLZ1h2wgY2oc54kSYydDrwc3l9hR/RxXTQGliacUTFWh
         Ujiq4ZOom0rdEoqIJ8sXw6N2rGdH8DSmg1TpcpRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/260] platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
Date:   Mon, 20 Sep 2021 18:41:18 +0200
Message-Id: <20210920163933.164087834@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index c97bd4a45242..5821e9d9a4ce 100644
--- a/drivers/platform/x86/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell-smbios-wmi.c
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



