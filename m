Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FCB2E1DF5
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgLWPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9CBE2333E;
        Wed, 23 Dec 2020 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737558;
        bh=AsSn1YqABH2ECGEo5TAiNBcozhkCc69btXrWjoyvPI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvvubvksCH9YrkHy5Ez1Nq21E3s1aoXDMURxkVpVFlKAjy175h7P9i42tj2PhoNRf
         +XeW7BhZAaxXC+yMr0tcINc9m9qwS6Zyn+6sY93nwOS3UCfnQLl9YGamCEomhs093x
         DLEx2lBLoEFkeTCSPfY644yBBV3pW+qD4G3D8oVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 01/40] net: ipconfig: Avoid spurious blank lines in boot log
Date:   Wed, 23 Dec 2020 16:33:02 +0100
Message-Id: <20201223150515.632736920@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit c9f64d1fc101c64ea2be1b2e562b4395127befc9 upstream.

When dumping the name and NTP servers advertised by DHCP, a blank line
is emitted if either of the lists is empty. This can lead to confusing
issues such as the blank line getting flagged as warning. This happens
because the blank line is the result of pr_cont("\n") and that may see
its level corrupted by some other driver concurrently writing to the
console.

Fix this by making sure that the terminating newline is only emitted
if at least one entry in the lists was printed before.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20201110073757.1284594-1-thierry.reding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ipconfig.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1441,7 +1441,7 @@ static int __init ip_auto_config(void)
 	int retries = CONF_OPEN_RETRIES;
 #endif
 	int err;
-	unsigned int i;
+	unsigned int i, count;
 
 	/* Initialise all name servers and NTP servers to NONE (but only if the
 	 * "ip=" or "nfsaddrs=" kernel command line parameters weren't decoded,
@@ -1575,7 +1575,7 @@ static int __init ip_auto_config(void)
 	if (ic_dev_mtu)
 		pr_cont(", mtu=%d", ic_dev_mtu);
 	/* Name servers (if any): */
-	for (i = 0; i < CONF_NAMESERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NAMESERVERS_MAX; i++) {
 		if (ic_nameservers[i] != NONE) {
 			if (i == 0)
 				pr_info("     nameserver%u=%pI4",
@@ -1583,12 +1583,14 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", nameserver%u=%pI4",
 					i, &ic_nameservers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NAMESERVERS_MAX)
+		if ((i + 1 == CONF_NAMESERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 	/* NTP servers (if any): */
-	for (i = 0; i < CONF_NTP_SERVERS_MAX; i++) {
+	for (i = 0, count = 0; i < CONF_NTP_SERVERS_MAX; i++) {
 		if (ic_ntp_servers[i] != NONE) {
 			if (i == 0)
 				pr_info("     ntpserver%u=%pI4",
@@ -1596,8 +1598,10 @@ static int __init ip_auto_config(void)
 			else
 				pr_cont(", ntpserver%u=%pI4",
 					i, &ic_ntp_servers[i]);
+
+			count++;
 		}
-		if (i + 1 == CONF_NTP_SERVERS_MAX)
+		if ((i + 1 == CONF_NTP_SERVERS_MAX) && count > 0)
 			pr_cont("\n");
 	}
 #endif /* !SILENT */


