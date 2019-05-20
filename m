Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DE123578
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391075AbfETMfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390407AbfETMfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:35:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4542204FD;
        Mon, 20 May 2019 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355720;
        bh=HC/idoCOQyV14h07TYHc6VAt31gFUcHJfANAqMDzakQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsPtb5jOkb93YTj6/ddGZ2QhNTxP/AqK2IOa/edPljdtk5DdSSLjsWdNV5aIzmaZx
         YMl+V9YwThuSqX7HAgtGCNot+LiIWwh/ydzXl+n4/L81QFFmwFhD8ctUJu+JKGRUtJ
         TVGidr9RG8R5U3qRAbnqQKXp7JFvl3ifliktsSYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamlakant Patel <kamlakantp@marvell.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.1 101/128] ipmi: Add the i2c-addr property for SSIF interfaces
Date:   Mon, 20 May 2019 14:14:48 +0200
Message-Id: <20190520115256.000435552@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

commit d73236383eb1cd4b7b65c33a09f0ed45f6781f40 upstream.

This is required for SSIF to work.

There was no way to know if the interface being added was SI
or SSIF from the platform data, but that was required so the
i2c-addr is only added for SSIF interfaces.  So add a field
for that.

Also rework the logic a bit so that ipmi-type is not set
for SSIF interfaces, as it is not necessary for that.

Fixes: 3cd83bac481d ("ipmi: Consolidate the adding of platform devices")
Reported-by: Kamlakant Patel <kamlakantp@marvell.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org # 5.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_dmi.c         |    2 ++
 drivers/char/ipmi/ipmi_plat_data.c   |   27 +++++++++++++++------------
 drivers/char/ipmi/ipmi_plat_data.h   |    3 +++
 drivers/char/ipmi/ipmi_si_hardcode.c |    1 +
 drivers/char/ipmi/ipmi_si_hotmod.c   |    1 +
 5 files changed, 22 insertions(+), 12 deletions(-)

--- a/drivers/char/ipmi/ipmi_dmi.c
+++ b/drivers/char/ipmi/ipmi_dmi.c
@@ -47,9 +47,11 @@ static void __init dmi_add_platform_ipmi
 	memset(&p, 0, sizeof(p));
 
 	name = "dmi-ipmi-si";
+	p.iftype = IPMI_PLAT_IF_SI;
 	switch (type) {
 	case IPMI_DMI_TYPE_SSIF:
 		name = "dmi-ipmi-ssif";
+		p.iftype = IPMI_PLAT_IF_SSIF;
 		p.type = SI_TYPE_INVALID;
 		break;
 	case IPMI_DMI_TYPE_BT:
--- a/drivers/char/ipmi/ipmi_plat_data.c
+++ b/drivers/char/ipmi/ipmi_plat_data.c
@@ -12,7 +12,7 @@ struct platform_device *ipmi_platform_ad
 					  struct ipmi_plat_data *p)
 {
 	struct platform_device *pdev;
-	unsigned int num_r = 1, size, pidx = 0;
+	unsigned int num_r = 1, size = 0, pidx = 0;
 	struct resource r[4];
 	struct property_entry pr[6];
 	u32 flags;
@@ -21,19 +21,22 @@ struct platform_device *ipmi_platform_ad
 	memset(pr, 0, sizeof(pr));
 	memset(r, 0, sizeof(r));
 
-	if (p->type == SI_BT)
-		size = 3;
-	else if (p->type == SI_TYPE_INVALID)
-		size = 0;
-	else
-		size = 2;
+	if (p->iftype == IPMI_PLAT_IF_SI) {
+		if (p->type == SI_BT)
+			size = 3;
+		else if (p->type != SI_TYPE_INVALID)
+			size = 2;
 
-	if (p->regsize == 0)
-		p->regsize = DEFAULT_REGSIZE;
-	if (p->regspacing == 0)
-		p->regspacing = p->regsize;
+		if (p->regsize == 0)
+			p->regsize = DEFAULT_REGSIZE;
+		if (p->regspacing == 0)
+			p->regspacing = p->regsize;
+
+		pr[pidx++] = PROPERTY_ENTRY_U8("ipmi-type", p->type);
+	} else if (p->iftype == IPMI_PLAT_IF_SSIF) {
+		pr[pidx++] = PROPERTY_ENTRY_U16("i2c-addr", p->addr);
+	}
 
-	pr[pidx++] = PROPERTY_ENTRY_U8("ipmi-type", p->type);
 	if (p->slave_addr)
 		pr[pidx++] = PROPERTY_ENTRY_U8("slave-addr", p->slave_addr);
 	pr[pidx++] = PROPERTY_ENTRY_U8("addr-source", p->addr_source);
--- a/drivers/char/ipmi/ipmi_plat_data.h
+++ b/drivers/char/ipmi/ipmi_plat_data.h
@@ -6,7 +6,10 @@
 
 #include <linux/ipmi.h>
 
+enum ipmi_plat_interface_type { IPMI_PLAT_IF_SI, IPMI_PLAT_IF_SSIF };
+
 struct ipmi_plat_data {
+	enum ipmi_plat_interface_type iftype;
 	unsigned int type; /* si_type for si, SI_INVALID for others */
 	unsigned int space; /* addr_space for si, intf# for ssif. */
 	unsigned long addr;
--- a/drivers/char/ipmi/ipmi_si_hardcode.c
+++ b/drivers/char/ipmi/ipmi_si_hardcode.c
@@ -83,6 +83,7 @@ static void __init ipmi_hardcode_init_on
 
 	memset(&p, 0, sizeof(p));
 
+	p.iftype = IPMI_PLAT_IF_SI;
 	if (!si_type_str || !*si_type_str || strcmp(si_type_str, "kcs") == 0) {
 		p.type = SI_KCS;
 	} else if (strcmp(si_type_str, "smic") == 0) {
--- a/drivers/char/ipmi/ipmi_si_hotmod.c
+++ b/drivers/char/ipmi/ipmi_si_hotmod.c
@@ -108,6 +108,7 @@ static int parse_hotmod_str(const char *
 	int rv;
 	unsigned int ival;
 
+	h->iftype = IPMI_PLAT_IF_SI;
 	rv = parse_str(hotmod_ops, &ival, "operation", &curr);
 	if (rv)
 		return rv;


