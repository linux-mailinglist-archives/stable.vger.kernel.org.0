Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147171D8598
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgERSTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgERRxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D376620674;
        Mon, 18 May 2020 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824430;
        bh=OVEPXqkdEHlw3GYRZgRCwXP6qOuH86MwaYU2UiQzTkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFY6A3IJ74y99o14F5iKFke3HHqivUOZpSq5jtIn3ZTMHpbAp+KTBadRPpvgTJeWl
         3Om7Jd665dMJ7OIGP83nvMW41IJFHSHAOLSFvWt46rEGNDWdMZOyBClB6yHWFwjDTN
         giXm9cbGf9pjGfjwaXhQnQsvVn4YuUMD1fOp3T+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 001/147] net: dsa: Do not make user port errors fatal
Date:   Mon, 18 May 2020 19:35:24 +0200
Message-Id: <20200518173513.232072492@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream.

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
 net/dsa/dsa2.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -461,18 +461,12 @@ static int dsa_tree_setup_switches(struc
 
 			err = dsa_port_setup(dp);
 			if (err)
-				goto ports_teardown;
+				continue;
 		}
 	}
 
 	return 0;
 
-ports_teardown:
-	for (i = 0; i < port; i++)
-		dsa_port_teardown(&ds->ports[i]);
-
-	dsa_switch_teardown(ds);
-
 switch_teardown:
 	for (i = 0; i < device; i++) {
 		ds = dst->ds[i];


