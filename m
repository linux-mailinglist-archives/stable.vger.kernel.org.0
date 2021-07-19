Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015C43CDC3C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbhGSOvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344257AbhGSOsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3913361279;
        Mon, 19 Jul 2021 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708475;
        bh=HklMvLiQ0ZurrPuUni8v0DxHMnK/beGzBC1+vRj/KR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzvcEkK6NL+lAhh8mKmMYUcBqrKZh4PF2rDtTak4pcc1qItoXB3AqRA/vXrAzgKZX
         yC7vL9WiV78YDdyl09I6OsHAw/J8e+V0s/QpigCiLsqEIXBLlWvAkdkzVhgzvsw9ko
         rx7F4D/qFfrqvRPoIRXJYjOfLSz5DbK9lmjTe6G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 288/315] PCI/sysfs: Fix dsm_label_utf16s_to_utf8s() buffer overrun
Date:   Mon, 19 Jul 2021 16:52:57 +0200
Message-Id: <20210719144952.911330566@linuxfoundation.org>
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
index a961a71d950f..6beafc1bee96 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -161,7 +161,7 @@ static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
 			      obj->buffer.length,
 			      UTF16_LITTLE_ENDIAN,
-			      buf, PAGE_SIZE);
+			      buf, PAGE_SIZE - 1);
 	buf[len] = '\n';
 }
 
-- 
2.30.2



