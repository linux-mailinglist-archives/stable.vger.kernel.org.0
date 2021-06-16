Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC56C3A9F93
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhFPPjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234634AbhFPPiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CCDF6101B;
        Wed, 16 Jun 2021 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857758;
        bh=47ONJBka8E/nJTEc3QV8/k45REhhZp/M8IwwixGjWjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0I4uQzBJy9tNmW2VMCmU4NDRWmUR6Dz3XCshcEMqmcjAhzmbOHCz5fOAPddBVPNQ
         Q72yXBUvUOatDMo/1MQt+LFr6Xm5rECFLiXt1HTCSfRNwG3jE7yZBYw+wxnKNuwmTo
         yfHm8Hi0ObUAcIkA8VyRb2EA0dvhOOe9hh5aoP4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/38] net: ipconfig: Dont override command-line hostnames or domains
Date:   Wed, 16 Jun 2021 17:33:38 +0200
Message-Id: <20210616152836.317968579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit b508d5fb69c2211a1b860fc058aafbefc3b3c3cd ]

If the user specifies a hostname or domain name as part of the ip=
command-line option, preserve it and don't overwrite it with one
supplied by DHCP/BOOTP.

For instance, ip=::::myhostname::dhcp will use "myhostname" rather than
ignoring and overwriting it.

Fix the comment on ic_bootp_string that suggests it only copies a string
"if not already set"; it doesn't have any such logic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipconfig.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 3cd13e1bc6a7..213a1c91507d 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -870,7 +870,7 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 
 
 /*
- *  Copy BOOTP-supplied string if not already set.
+ *  Copy BOOTP-supplied string
  */
 static int __init ic_bootp_string(char *dest, char *src, int len, int max)
 {
@@ -919,12 +919,15 @@ static void __init ic_do_bootp_ext(u8 *ext)
 		}
 		break;
 	case 12:	/* Host name */
-		ic_bootp_string(utsname()->nodename, ext+1, *ext,
-				__NEW_UTS_LEN);
-		ic_host_name_set = 1;
+		if (!ic_host_name_set) {
+			ic_bootp_string(utsname()->nodename, ext+1, *ext,
+					__NEW_UTS_LEN);
+			ic_host_name_set = 1;
+		}
 		break;
 	case 15:	/* Domain name (DNS) */
-		ic_bootp_string(ic_domain, ext+1, *ext, sizeof(ic_domain));
+		if (!ic_domain[0])
+			ic_bootp_string(ic_domain, ext+1, *ext, sizeof(ic_domain));
 		break;
 	case 17:	/* Root path */
 		if (!root_server_path[0])
-- 
2.30.2



