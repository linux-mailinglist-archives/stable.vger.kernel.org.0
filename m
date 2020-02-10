Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7470D157BC0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgBJNcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgBJMfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:50 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6847215A4;
        Mon, 10 Feb 2020 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338149;
        bh=7S+nz84V2XBwIG/SFHIOdFnJ93coRYt3lxMrqd/7a2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJySgIVeqG6nE998HDkf4gvxGmrczKdrta6VoK50jELtwg1/YCrzyiSdc7AOx0mnX
         r6drmITaMCZmOf2kdytqxPmnnEPl/72Orx1PifeJ/hJHYqtASTbCS8z+Q/OL1zgX+G
         fro740vIzAl15FE1zsMJbdvXkiechByhGzCR64WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Frank Sorenson <sorenson@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.19 112/195] sunrpc: expiry_time should be seconds not timeval
Date:   Mon, 10 Feb 2020 04:32:50 -0800
Message-Id: <20200210122316.459145421@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

commit 3d96208c30f84d6edf9ab4fac813306ac0d20c10 upstream.

When upcalling gssproxy, cache_head.expiry_time is set as a
timeval, not seconds since boot. As such, RPC cache expiry
logic will not clean expired objects created under
auth.rpcsec.context cache.

This has proven to cause kernel memory leaks on field. Using
64 bit variants of getboottime/timespec

Expiration times have worked this way since 2010's c5b29f885afe "sunrpc:
use seconds since boot in expiry cache".  The gssproxy code introduced
in 2012 added gss_proxy_save_rsc and introduced the bug.  That's a while
for this to lurk, but it required a bit of an extreme case to make it
obvious.

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 030d794bf498 "SUNRPC: Use gssproxy upcall for server..."
Tested-By: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/svcauth_gss.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1224,6 +1224,7 @@ static int gss_proxy_save_rsc(struct cac
 		dprintk("RPC:       No creds found!\n");
 		goto out;
 	} else {
+		struct timespec64 boot;
 
 		/* steal creds */
 		rsci.cred = ud->creds;
@@ -1244,6 +1245,9 @@ static int gss_proxy_save_rsc(struct cac
 						&expiry, GFP_KERNEL);
 		if (status)
 			goto out;
+
+		getboottime64(&boot);
+		expiry -= boot.tv_sec;
 	}
 
 	rsci.h.expiry_time = expiry;


