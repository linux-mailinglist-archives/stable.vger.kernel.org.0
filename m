Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3FD3CE4F7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346870AbhGSPrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349493AbhGSPpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FDE26128C;
        Mon, 19 Jul 2021 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711917;
        bh=4KsKW8tFlrctLEkYf5y+b9RxZ2NggOdutywFRqIHSJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltn1ErqsOqGZTPJlTvLCBiR2SRsPxIH0FWNK42NmJKVCoe4S9WA5zToMMMm6CSZGF
         i9zuHgC4KxOeSRT8wTEC07GuIbpbs7Qc5JVJNhLJu8RuUhdduZtx5cUpxsK8XJZoVV
         xz1MxRKOAoCNFr3WN0Z5j4MC3NqGy5wPWYoZJa88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 180/292] PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun
Date:   Mon, 19 Jul 2021 16:54:02 +0200
Message-Id: <20210719144948.415289448@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit bdcdaa13ad96f1a530711c29e6d4b8311eff767c ]

"utf16s_to_utf8s(..., buf, PAGE_SIZE)" puts up to PAGE_SIZE bytes into
"buf" and returns the number of bytes it actually put there.  If it wrote
PAGE_SIZE bytes, the newline added by dsm_label_utf16s_to_utf8s() would
overrun "buf".

Reduce the size available for utf16s_to_utf8s() to use so there is always
space for the newline.

[bhelgaas: reorder patch in series, commit log]
Fixes: 6058989bad05 ("PCI: Export ACPI _DSM provided firmware instance number and string name to sysfs")
Link: https://lore.kernel.org/r/20210603000112.703037-7-kw@linux.com
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 781e45cf60d1..cd84cf52a92e 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -162,7 +162,7 @@ static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
 			      obj->buffer.length,
 			      UTF16_LITTLE_ENDIAN,
-			      buf, PAGE_SIZE);
+			      buf, PAGE_SIZE - 1);
 	buf[len] = '\n';
 }
 
-- 
2.30.2



