Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A702C1D0E5C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbgEMJwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgEMJwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CDD20575;
        Wed, 13 May 2020 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363536;
        bh=Vv9PhfdE/RaWowcul5qnKTkgLbCXCDjFn8b2JC2Q9co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYmskubFlxIapZvDE3kf7ISJ+cWsfeB5U3osrVXEemjKPvWDBTuoYytrisoy1tgNu
         FQ/QsBg+cfMMwYcw31RgMHC64C58AiNUfERtzzH4vzovgnhdC9lqWHPn8GL23teWuY
         BmAo2BIHv7Zh5mwEmpjZKmWEC7wFiq3mGeZmLBTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 023/118] net: dsa: Do not make user port errors fatal
Date:   Wed, 13 May 2020 11:44:02 +0200
Message-Id: <20200513094419.723032920@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 86f8b1c01a0a537a73d2996615133be63cdf75db ]

Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
not treat failures to set-up an user port as fatal, but after this
commit we would, which is a regression for some systems where interfaces
may be declared in the Device Tree, but the underlying hardware may not
be present (pluggable daughter cards for instance).

Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/dsa2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -459,7 +459,7 @@ static int dsa_tree_setup_switches(struc
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
 		if (err)
-			goto teardown;
+			continue;
 	}
 
 	return 0;


