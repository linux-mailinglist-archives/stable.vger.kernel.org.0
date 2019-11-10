Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C05F622C
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKJCkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbfKJCki (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5303921D7B;
        Sun, 10 Nov 2019 02:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353637;
        bh=+mucMr6A/hRINmaccGje7YrhL8FrsBd+/9b1Se5ecYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr3zOdCN0tdtMG9eFLThLhxqSdKOnNB5thFuQ0DVweUgHK1aJvU+4869NCOkAOtyY
         0KfIg6sF1LcGQdEZyZy13TEcWm3DpOMK2bhs6Tmf0Pemn6v1wcs9DrPWAGlUoEMihb
         q2aTOkIOxzP5UyF6xvKwq4TvVig4v/Xrnjh/yrjs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 021/191] ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address
Date:   Sat,  9 Nov 2019 21:37:23 -0500
Message-Id: <20191110024013.29782-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
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
index e2c143861b1e5..28dbd5529188a 100644
--- a/drivers/char/ipmi/ipmi_dmi.c
+++ b/drivers/char/ipmi/ipmi_dmi.c
@@ -217,6 +217,10 @@ static void __init dmi_decode_ipmi(const struct dmi_header *dm)
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

