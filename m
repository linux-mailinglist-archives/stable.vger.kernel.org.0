Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC494924F
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfFQVTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbfFQVS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:18:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA10208E4;
        Mon, 17 Jun 2019 21:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806337;
        bh=Hdy65pl9aaW/j2RWGkgGiRNaTj6XOwC3oaVLul7OVVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXQzxvKnI1p4U6UiqFKwvIPe73Lul795zEWMKFhxM1+KWURoYJmK6C1kC1GD9W71r
         kL5Gb5mT101qJg8vA/Ykgnv6xblGVBRStBdG/rocK6Te8DygegGRVCJJe30B2LMis2
         Slv6U3pv+Jiy4h4n3onUrT6LSI4PrEvXTnOCheIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gen Zhang <blackgod016574@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.1 018/115] selinux: fix a missing-check bug in selinux_add_mnt_opt( )
Date:   Mon, 17 Jun 2019 23:08:38 +0200
Message-Id: <20190617210800.846376843@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

commit e2e0e09758a6f7597de0f9b819647addfb71b6bd upstream.

In selinux_add_mnt_opt(), 'val' is allocated by kmemdup_nul(). It returns
NULL when fails. So 'val' should be checked. And 'mnt_opts' should be
freed when error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Fixes: 757cbe597fe8 ("LSM: new method: ->sb_add_mnt_opt()")
Cc: <stable@vger.kernel.org>
[PM: fixed some indenting problems]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1048,15 +1048,24 @@ static int selinux_add_mnt_opt(const cha
 	if (token == Opt_error)
 		return -EINVAL;
 
-	if (token != Opt_seclabel)
+	if (token != Opt_seclabel) {
 		val = kmemdup_nul(val, len, GFP_KERNEL);
+		if (!val) {
+			rc = -ENOMEM;
+			goto free_opt;
+		}
+	}
 	rc = selinux_add_opt(token, val, mnt_opts);
 	if (unlikely(rc)) {
 		kfree(val);
-		if (*mnt_opts) {
-			selinux_free_mnt_opts(*mnt_opts);
-			*mnt_opts = NULL;
-		}
+		goto free_opt;
+	}
+	return rc;
+
+free_opt:
+	if (*mnt_opts) {
+		selinux_free_mnt_opts(*mnt_opts);
+		*mnt_opts = NULL;
 	}
 	return rc;
 }


