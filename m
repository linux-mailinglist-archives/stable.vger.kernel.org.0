Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954D4101492
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfKSFfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728251AbfKSFfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59DC721783;
        Tue, 19 Nov 2019 05:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141715;
        bh=+mucMr6A/hRINmaccGje7YrhL8FrsBd+/9b1Se5ecYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4PPQ0NzvEVUXgGeKpCFMyCsshLP0lNawGRLinKoSFoF2plkvMKjcV4hpLJLs1Rdj
         R+LZwzs3TrvF5MN1p7EfXr/BzhImkI771QMCkrmdJfLVvqAvr7yz8FSsyAcIAKkQbI
         kpgbWR/53xOLN3mtHm2HxqXD2MXHhuNnTcsuO+Ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/422] ipmi:dmi: Ignore IPMI SMBIOS entries with a zero base address
Date:   Tue, 19 Nov 2019 06:17:32 +0100
Message-Id: <20191119051415.511427735@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



