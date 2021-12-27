Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06724800E1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbhL0PvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhL0Pr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:47:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61525C08EAEB;
        Mon, 27 Dec 2021 07:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D041B810CC;
        Mon, 27 Dec 2021 15:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB16C36AEA;
        Mon, 27 Dec 2021 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619810;
        bh=BEmlgkvqRJDu7LM1uiQZK4A0FdbActFMkSVyx4LKvns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1QtMIVAOIXSJ75ZS3hR3glkyhX05aeH9aFHCuK5pzpDw5DzYtC3lMGZ9e7qy8bDh
         /Qvi9tifYDL+E+n/HOsouCHQZauiFkX3nU6hgUz6D3lWhQSkwMNzLzpNDm04SRrw5R
         4wosBa3aENF6WT3rc3vatuf/39WLCOKs5FJE2Yr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.15 077/128] ipmi: bail out if init_srcu_struct fails
Date:   Mon, 27 Dec 2021 16:30:52 +0100
Message-Id: <20211227151334.077304536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 2b5160b12091285c5aca45980f100a9294af7b04 upstream.

In case, init_srcu_struct fails (because of memory allocation failure), we
might proceed with the driver initialization despite srcu_struct not being
entirely initialized.

Fixes: 913a89f009d9 ("ipmi: Don't initialize anything in the core until something uses it")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org
Message-Id: <20211217154410.1228673-1-cascardo@canonical.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -5148,7 +5148,9 @@ static int ipmi_init_msghandler(void)
 	if (initialized)
 		goto out;
 
-	init_srcu_struct(&ipmi_interfaces_srcu);
+	rv = init_srcu_struct(&ipmi_interfaces_srcu);
+	if (rv)
+		goto out;
 
 	timer_setup(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);


