Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB2026607C
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 15:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgIKNm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgIKN20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:28:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D03122456;
        Fri, 11 Sep 2020 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829181;
        bh=ybDPXSWX6t6Yrp5Uds0fPcMTpwzBemoFk3ybMUuZEyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1M/FByuPrgNq1JusDVuk1YhRm/doUstz9Ea9u/uS4/HHmulwV7a7t78H2gKn3SS4e
         IiSqSKDY8PuiAkh43pW8Ea6+ZwGX8hF6zSnP2ICrRynkgC8wrzBSdZhhZ7fa1nS3U1
         oGplK8zKCSVpBZ/UfsUuR/vN95PGSdnB/cGyZDJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 14/16] tipc: fix using smp_processor_id() in preemptible
Date:   Fri, 11 Sep 2020 14:47:31 +0200
Message-Id: <20200911122500.284435224@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit bb8872a1e6bc911869a729240781076ed950764b ]

The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
CPU for encryption, however the execution can be preemptible since it's
actually user-space context, so the 'using smp_processor_id() in
preemptible' has been observed.

We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
a 'preempt_disable()' instead.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_he
 	if (aead->cloned) {
 		tipc_aead_put(aead->cloned);
 	} else {
-		head = *this_cpu_ptr(aead->tfm_entry);
+		head = *get_cpu_ptr(aead->tfm_entry);
+		put_cpu_ptr(aead->tfm_entry);
 		list_for_each_entry_safe(tfm_entry, tmp, &head->list, list) {
 			crypto_free_aead(tfm_entry->tfm);
 			list_del(&tfm_entry->list);
@@ -399,10 +400,15 @@ static void tipc_aead_users_set(struct t
  */
 static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
 {
-	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
+	struct tipc_tfm **tfm_entry;
+	struct crypto_aead *tfm;
 
+	tfm_entry = get_cpu_ptr(aead->tfm_entry);
 	*tfm_entry = list_next_entry(*tfm_entry, list);
-	return (*tfm_entry)->tfm;
+	tfm = (*tfm_entry)->tfm;
+	put_cpu_ptr(tfm_entry);
+
+	return tfm;
 }
 
 /**


