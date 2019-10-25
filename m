Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D4CE5310
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfJYSHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46776 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731426AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OO-PW; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001iW-Bi; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nicolas Dichtel" <nicolas.dichtel@6wind.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Anirudh Gupta" <anirudh.gupta@sophos.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 25 Oct 2019 19:03:14 +0100
Message-ID: <lsq.1572026582.942700400@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 13/47] xfrm: fix sa selector validation
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit b8d6d0079757cbd1b69724cfd1c08e2171c68cee upstream.

After commit b38ff4075a80, the following command does not work anymore:
$ ip xfrm state add src 10.125.0.2 dst 10.125.0.1 proto esp spi 34 reqid 1 \
  mode tunnel enc 'cbc(aes)' 0xb0abdba8b782ad9d364ec81e3a7d82a1 auth-trunc \
  'hmac(sha1)' 0xe26609ebd00acb6a4d51fca13e49ea78a72c73e6 96 flag align4

In fact, the selector is not mandatory, allow the user to provide an empty
selector.

Fixes: b38ff4075a80 ("xfrm: Fix xfrm sel prefix length validation")
CC: Anirudh Gupta <anirudh.gupta@sophos.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -165,6 +165,9 @@ static int verify_newsa_info(struct xfrm
 	}
 
 	switch (p->sel.family) {
+	case AF_UNSPEC:
+		break;
+
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;

