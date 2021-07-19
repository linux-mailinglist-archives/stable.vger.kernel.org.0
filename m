Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9B3CD93E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243965AbhGSO1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243281AbhGSO0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:26:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C50761242;
        Mon, 19 Jul 2021 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707214;
        bh=HRsLykcVAM6qb97IVwJWQm1m7XYOy2U68fbD+4dniOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB1vZGDM/Jk2Pp+akPhTPx0HEb0p+7K0OUIG9/MbZeR+0Y3D06PL83/CseTttr1rh
         xO/j+QM9Ia27vA8dN8TTO1ywrOWM/0NqosQyn5ACqLrTaUUWjSxh4AfApKNxwfopub
         kSO8WLDlaKKUUgkiO+ygpuVEpKYrFus1MXCoU/aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/245] ACPI: sysfs: Fix a buffer overrun problem with description_show()
Date:   Mon, 19 Jul 2021 16:50:15 +0200
Message-Id: <20210719144942.772942786@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit 888be6067b97132c3992866bbcf647572253ab3f ]

Currently, a device description can be obtained using ACPI, if the _STR
method exists for a particular device, and then exposed to the userspace
via a sysfs object as a string value.

If the _STR method is available for a given device then the data
(usually a Unicode string) is read and stored in a buffer (of the
ACPI_TYPE_BUFFER type) with a pointer to said buffer cached in the
struct acpi_device_pnp for later access.

The description_show() function is responsible for exposing the device
description to the userspace via a corresponding sysfs object and
internally calls the utf16s_to_utf8s() function with a pointer to the
buffer that contains the Unicode string so that it can be converted from
UTF16 encoding to UTF8 and thus allowing for the value to be safely
stored and later displayed.

When invoking the utf16s_to_utf8s() function, the description_show()
function also sets a limit of the data that can be saved into a provided
buffer as a result of the character conversion to be a total of
PAGE_SIZE, and upon completion, the utf16s_to_utf8s() function returns
an integer value denoting the number of bytes that have been written
into the provided buffer.

Following the execution of the utf16s_to_utf8s() a newline character
will be added at the end of the resulting buffer so that when the value
is read in the userspace through the sysfs object then it would include
newline making it more accessible when working with the sysfs file
system in the shell, etc.  Normally, this wouldn't be a problem, but if
the function utf16s_to_utf8s() happens to return the number of bytes
written to be precisely PAGE_SIZE, then we would overrun the buffer and
write the newline character outside the allotted space which can have
undefined consequences or result in a failure.

To fix this buffer overrun, ensure that there always is enough space
left for the newline character to be safely appended.

Fixes: d1efe3c324ea ("ACPI: Add new sysfs interface to export device description")
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index fb610ad495f1..152ba55fd908 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -452,7 +452,7 @@ static ssize_t description_show(struct device *dev,
 		(wchar_t *)acpi_dev->pnp.str_obj->buffer.pointer,
 		acpi_dev->pnp.str_obj->buffer.length,
 		UTF16_LITTLE_ENDIAN, buf,
-		PAGE_SIZE);
+		PAGE_SIZE - 1);
 
 	buf[result++] = '\n';
 
-- 
2.30.2



