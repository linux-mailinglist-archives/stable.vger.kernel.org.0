Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202BD47FF17
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbhL0PfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39764 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238162AbhL0PfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59069CE10B6;
        Mon, 27 Dec 2021 15:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28096C36AE7;
        Mon, 27 Dec 2021 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619306;
        bh=R4tZ80uam6UsmuLNMhP7DQ0TOfnMtcu+gfsg/K6c7jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCdL//N9ETEfenxpgzQluL/Ghd6qTWezUa152o5ydJ7YHDbJYIZE2acLiadFPx9EJ
         U1qHwRwWxoORqoYstyUZ+1xySJ6onmNOqIeU0vYj/crr+qzLkLUuNrCV938hO5/zPN
         PXHvkMNx7GPy3H1SExdBGOKpJEkp+jwpjWwt3XXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 26/47] ipmi: bail out if init_srcu_struct fails
Date:   Mon, 27 Dec 2021 16:31:02 +0100
Message-Id: <20211227151321.703382890@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
@@ -5156,7 +5156,9 @@ static int ipmi_init_msghandler(void)
 	if (initialized)
 		goto out;
 
-	init_srcu_struct(&ipmi_interfaces_srcu);
+	rv = init_srcu_struct(&ipmi_interfaces_srcu);
+	if (rv)
+		goto out;
 
 	timer_setup(&ipmi_timer, ipmi_timeout, 0);
 	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);


