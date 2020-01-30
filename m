Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7514E211
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgA3StV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbgA3Ssj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B074220CC7;
        Thu, 30 Jan 2020 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410119;
        bh=AgpXlJbli/9L7qbemL8DxcROTQAomKZ18xUHp2up7GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZP3lozFw1V27qz3PdSH3i4lA/OKZ2J5sgYJIEyykUOqit27cgjmr9ix9g/9krcPO
         H38zymSLv/be2BEfCAG4Nn1axE9p5eWTR9PRvYjOhrbqW2f+f6dV3HHHMjxbWtT+UJ
         Tz29UkaJNp2gccCmp3/BNfjzLg9+0tWsBJGUtiTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>
Subject: [PATCH 4.19 14/55] component: do not dereference opaque pointer in debugfs
Date:   Thu, 30 Jan 2020 19:38:55 +0100
Message-Id: <20200130183611.446214525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

commit ef9ffc1e5f1ac73ecd2fb3b70db2a3b2472ff2f7 upstream.

The match data does not have to be a struct device pointer, and indeed
very often is not. Attempt to treat it as such easily results in a
crash.

For the components that are not registered, we don't know which device
is missing. Once it it is there, we can use the struct component to get
the device and whether it's bound or not.

Fixes: 59e73854b5fd ('component: add debugfs support')
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: stable <stable@vger.kernel.org>
Cc: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20191118115431.63626-1-lkundrak@v3.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/component.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -74,11 +74,11 @@ static int component_devices_show(struct
 	seq_printf(s, "%-40s %20s\n", "device name", "status");
 	seq_puts(s, "-------------------------------------------------------------\n");
 	for (i = 0; i < match->num; i++) {
-		struct device *d = (struct device *)match->compare[i].data;
+		struct component *component = match->compare[i].component;
 
-		seq_printf(s, "%-40s %20s\n", dev_name(d),
-			   match->compare[i].component ?
-			   "registered" : "not registered");
+		seq_printf(s, "%-40s %20s\n",
+			   component ? dev_name(component->dev) : "(unknown)",
+			   component ? (component->bound ? "bound" : "not bound") : "not registered");
 	}
 	mutex_unlock(&component_mutex);
 


