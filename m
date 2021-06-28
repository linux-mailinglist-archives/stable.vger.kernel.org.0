Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C33B6398
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhF1O63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236950AbhF1O41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D0436144E;
        Mon, 28 Jun 2021 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891213;
        bh=PFgFgnKcebF8jjQMVTBtUDusT7F8dEi55MEb6Jc3/Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhQ+BzrU3H2LIXw0L0EJATueWIglHz8C8R8kiYDsncHd633/7s0JtyPMPJ760Dmm9
         wfLW2Tu3WaqYNX4LGp7eoN0XCzZdN7jxSR2FI7ynrpvva+elC6DLMkEsVo6YfAxnzj
         4eVViUo5neMG7fdQtP1BBruoRMwnWRzcM9Fue7ZWADOIu34IAlws5xc2kv8FpsxOZb
         NtjX+00LCLvvnLKXlL7UDysM8cM6azYcPbHTk7+vg30iXuw5F7I6e0cyliV6xsKb0e
         QFQQ4TUA3dZegyL9Ha3MuK/3uwQBmTnoPQVU2G3Ym741v7HGC0lEVP3nXAbFM471zd
         p9+xLl6FTuyBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/71] net: ipconfig: Don't override command-line hostnames or domains
Date:   Mon, 28 Jun 2021 10:39:02 -0400
Message-Id: <20210628144003.34260-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index d278b06459ac..79d8ea98a5b1 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -880,7 +880,7 @@ static void __init ic_bootp_send_if(struct ic_device *d, unsigned long jiffies_d
 
 
 /*
- *  Copy BOOTP-supplied string if not already set.
+ *  Copy BOOTP-supplied string
  */
 static int __init ic_bootp_string(char *dest, char *src, int len, int max)
 {
@@ -929,12 +929,15 @@ static void __init ic_do_bootp_ext(u8 *ext)
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

