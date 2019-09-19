Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A32AB8480
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393600AbfISWLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393595AbfISWLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5EE8218AF;
        Thu, 19 Sep 2019 22:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931090;
        bh=CmiYWrCziYWwm/L7yhLnm4McX5taLlSI0gBZlUARNcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPwZ97055epYiOqafzcZglfFRGhoRcey/h8PdkO1blGT1XS8HxYFAZXNw1DMuzKMm
         il4ewKKDYK9vVkr0ipuLocuzPa94qywKvamRKK3iif0hkzF8/a7CQ2bLYT99ILCs8U
         EQPvdnb0rHN5iZnKK1a4i5PYh2S7U+Xjl+tb4Efo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.2 124/124] vfs: Fix refcounting of filenames in fs_parser
Date:   Fri, 20 Sep 2019 00:03:32 +0200
Message-Id: <20190919214823.713060325@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 7cdfa44227b0d8842d46a775cebe4311150cb8f2 upstream.

Fix an overput in which filename_lookup() unconditionally drops a ref to
the filename it was given, but this isn't taken account of in the caller,
fs_lookup_param().

Addresses-Coverity-ID: 1443811 ("Use after free")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs_parser.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -264,6 +264,7 @@ int fs_lookup_param(struct fs_context *f
 		return invalf(fc, "%s: not usable as path", param->key);
 	}
 
+	f->refcnt++; /* filename_lookup() drops our ref. */
 	ret = filename_lookup(param->dirfd, f, flags, _path, NULL);
 	if (ret < 0) {
 		errorf(fc, "%s: Lookup failure for '%s'", param->key, f->name);


