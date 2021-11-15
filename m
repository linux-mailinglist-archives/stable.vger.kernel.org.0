Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E7645247D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351960AbhKPBjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241831AbhKOSb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B347632D3;
        Mon, 15 Nov 2021 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999123;
        bh=H4UdQsdKJfCSJcdUiBMAqHk4UcOMJiONTCMuI4jtRXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WExDRVBWmTuxDCKF2eUINFUvMCSrn8/LppcS9CPxLJJQWHCGL02m8tSEMd5NWsx73
         n6fJHPPim9Lr2cBOPVemhYjQE/a3a7AyBl+3Lr3e2aoqTOicsE2HqxuF6xqgaCU2u8
         j6TwDqmIzl5XuunXfg2Mvd0rnsYahtTjZ9S7RXas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 185/849] cifs: set a minimum of 120s for next dns resolution
Date:   Mon, 15 Nov 2021 17:54:28 +0100
Message-Id: <20211115165426.439164758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 4ac0536f8874a903a72bddc57eb88db774261e3a upstream.

With commit 506c1da44fee ("cifs: use the expiry output of dns_query to
schedule next resolution") and after triggering the first reconnect,
the next async dns resolution of tcp server's hostname would be
scheduled based on dns_resolver's key expiry default, which happens to
default to 5s on most systems that use key.dns_resolver for upcall.

As per key.dns_resolver.conf(5):

       default_ttl=<number>
              The  number  of  seconds  to  set  as the expiration on a cached
              record.  This will be overridden if the program manages  to  re-
              trieve  TTL  information along with the addresses (if, for exam-
              ple, it accesses the DNS directly).  The default is  5  seconds.
              The value must be in the range 1 to INT_MAX.

Make the next async dns resolution no shorter than 120s as we do not
want to be upcalling too often.

Cc: stable@vger.kernel.org
Fixes: 506c1da44fee ("cifs: use the expiry output of dns_query to schedule next resolution")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |    3 ++-
 fs/cifs/connect.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -75,7 +75,8 @@
 #define SMB_ECHO_INTERVAL_MAX 600
 #define SMB_ECHO_INTERVAL_DEFAULT 60
 
-/* dns resolution interval in seconds */
+/* dns resolution intervals in seconds */
+#define SMB_DNS_RESOLVE_INTERVAL_MIN     120
 #define SMB_DNS_RESOLVE_INTERVAL_DEFAULT 600
 
 /* maximum number of PDUs in one compound */
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -116,7 +116,7 @@ static int reconn_set_ipaddr_from_hostna
 			 * To make sure we don't use the cached entry, retry 1s
 			 * after expiry.
 			 */
-			ttl = (expiry - now + 1);
+			ttl = max_t(unsigned long, expiry - now, SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
 	}
 	rc = !rc ? -1 : 0;
 


