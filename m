Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E65624ED
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387406AbfGHPU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387522AbfGHPU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A646621537;
        Mon,  8 Jul 2019 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599227;
        bh=z4YLawLAL+RAstkCPjuuCG8qe90luDJo+9TJD4mvhqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vq9qmNv0TXYvsmgY5lsKT9cCuyuqBVzYeLSzVdI9yxUE3ZbA+OVxHDiUWs7mPVzgb
         XLA0sAr2SZktsi4i4LYZLuovKRMUCAcplmQFvhFn9dx37H4lggVwqc7sSi+gCt5dvi
         RsWlGT+sr1qDoTleygF64oBCeVfyRWLw0id1bwb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4.9 007/102] apparmor: enforce nullbyte at end of tag string
Date:   Mon,  8 Jul 2019 17:12:00 +0200
Message-Id: <20190708150526.384607295@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 8404d7a674c49278607d19726e0acc0cae299357 upstream.

A packed AppArmor policy contains null-terminated tag strings that are read
by unpack_nameX(). However, unpack_nameX() uses string functions on them
without ensuring that they are actually null-terminated, potentially
leading to out-of-bounds accesses.

Make sure that the tag string is null-terminated before passing it to
strcmp().

Cc: stable@vger.kernel.org
Fixes: 736ec752d95e ("AppArmor: policy routines for loading and unpacking policy")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/policy_unpack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -177,7 +177,7 @@ static bool unpack_nameX(struct aa_ext *
 		char *tag = NULL;
 		size_t size = unpack_u16_chunk(e, &tag);
 		/* if a name is specified it must match. otherwise skip tag */
-		if (name && (!size || strcmp(name, tag)))
+		if (name && (!size || tag[size-1] != '\0' || strcmp(name, tag)))
 			goto fail;
 	} else if (name) {
 		/* if a name is specified and there is no name tag fail */


