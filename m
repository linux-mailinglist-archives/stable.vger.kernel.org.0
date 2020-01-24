Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E60147AF0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731723AbgAXJje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgAXJjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D6C2070A;
        Fri, 24 Jan 2020 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858773;
        bh=uDfNVJ2e3B9w85wc4tQZGUV7MtasnpvtfhWO9cknEl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE9HhlC+dWhqHkD+htxhDVOurmaOjeDWOaYShnWZLYXinY1O+tXlPtYKQmzNbYz9l
         g4yCUakv9uycYl0H3M8NW652h7IxU4PkgQqkjVD6MVh+ptOEEBDC/2Ob+apasuoL3/
         yuL3HriJnNQIbkg7OPHXXhMMVIQo/3osDga2M4XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Steinhardt <ps@pks.im>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 036/102] nfsd: depend on CRYPTO_MD5 for legacy client tracking
Date:   Fri, 24 Jan 2020 10:30:37 +0100
Message-Id: <20200124092811.711425818@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

commit 38a2204f5298620e8a1c3b1dc7b831425106dbc0 upstream.

The legacy client tracking infrastructure of nfsd makes use of MD5 to
derive a client's recovery directory name. As the nfsd module doesn't
declare any dependency on CRYPTO_MD5, though, it may fail to allocate
the hash if the kernel was compiled without it. As a result, generation
of client recovery directories will fail with the following error:

    NFSD: unable to generate recoverydir name

The explicit dependency on CRYPTO_MD5 was removed as redundant back in
6aaa67b5f3b9 (NFSD: Remove redundant "select" clauses in fs/Kconfig
2008-02-11) as it was already implicitly selected via RPCSEC_GSS_KRB5.
This broke when RPCSEC_GSS_KRB5 was made optional for NFSv4 in commit
df486a25900f (NFS: Fix the selection of security flavours in Kconfig) at
a later point.

Fix the issue by adding back an explicit dependency on CRYPTO_MD5.

Fixes: df486a25900f (NFS: Fix the selection of security flavours in Kconfig)
Signed-off-by: Patrick Steinhardt <ps@pks.im>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -73,6 +73,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
+	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select GRACE_PERIOD
 	help


