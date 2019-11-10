Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B41F6560
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKJDG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbfKJCpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEF8222C5;
        Sun, 10 Nov 2019 02:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353950;
        bh=5x+LmrqeEnbeK59deb9In/L3b8XEmOiclhXJ0kY79ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r48/ujtOM1IOFBVZEGYIh1MSi6hLUHQPjbcFQqqRIKVzXs0+w8EGwIHKY4CKiL5FR
         vRUn2NME5/ZQkka8jFQB/HYaZwSw1ya9QmTd7i1IWu7cNZqe312NHoW+tDKlgpqNdg
         8dWfYpIebnAr50n9fSWw5s+XtgpMRFY0RB3p/mNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 008/109] ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address
Date:   Sat,  9 Nov 2019 21:44:00 -0500
Message-Id: <20191110024541.31567-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 1574608f5f4204440d6d9f52b971aba967664764 ]

Looking at logs from systems all over the place, it looks like tons
of broken systems exist that set the base address to zero.  I can
only guess that is some sort of non-standard idea to mark the
interface as not being present.  It can't be zero, anyway, so just
complain and ignore it.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_dmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_dmi.c b/drivers/char/ipmi/ipmi_dmi.c
index c3a23ec3e76f7..a37d9794170cc 100644
--- a/drivers/char/ipmi/ipmi_dmi.c
+++ b/drivers/char/ipmi/ipmi_dmi.c
@@ -197,6 +197,10 @@ static void __init dmi_decode_ipmi(const struct dmi_header *dm)
 	slave_addr = data[DMI_IPMI_SLAVEADDR];
 
 	memcpy(&base_addr, data + DMI_IPMI_ADDR, sizeof(unsigned long));
+	if (!base_addr) {
+		pr_err("Base address is zero, assuming no IPMI interface\n");
+		return;
+	}
 	if (len >= DMI_IPMI_VER2_LENGTH) {
 		if (type == IPMI_DMI_TYPE_SSIF) {
 			offset = 0;
-- 
2.20.1

