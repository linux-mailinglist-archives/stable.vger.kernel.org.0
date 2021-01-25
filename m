Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8438D304AF9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbhAZExj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbhAYSrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEEF1224BE;
        Mon, 25 Jan 2021 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600430;
        bh=DRaBQNii7okTU7Y6WLb9KoJToxoFiwRVPO0x4HMcFVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QO0LVprOjp54S0oqjMarbrclIl7H2URp8gDkJ5GXu37WF5fN69mPvxAcyoXndgA8S
         3aC8hy205zPGx3cKdsSLOjZW21qpnQ7ZVUesmWLCSC/H2JEwni0+shpJfvGEdfi3QB
         od9RCtZZ68sutiQoOxYa5b1rR+PW02XX1Id3Kol4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 012/199] dm crypt: fix copy and paste bug in crypt_alloc_req_aead
Date:   Mon, 25 Jan 2021 19:37:14 +0100
Message-Id: <20210125183216.774291856@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

commit 004b8ae9e2de55ca7857ba8471209dd3179e088c upstream.

In commit d68b29584c25 ("dm crypt: use GFP_ATOMIC when allocating
crypto requests from softirq") code was incorrectly copy and pasted
from crypt_alloc_req_skcipher()'s crypto request allocation code to
crypt_alloc_req_aead(). It is OK from runtime perspective as both
simple encryption request pointer and AEAD request pointer are part of
a union, but may confuse code reviewers.

Fixes: d68b29584c25 ("dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1481,9 +1481,9 @@ static int crypt_alloc_req_skcipher(stru
 static int crypt_alloc_req_aead(struct crypt_config *cc,
 				 struct convert_context *ctx)
 {
-	if (!ctx->r.req) {
-		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
-		if (!ctx->r.req)
+	if (!ctx->r.req_aead) {
+		ctx->r.req_aead = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
+		if (!ctx->r.req_aead)
 			return -ENOMEM;
 	}
 


