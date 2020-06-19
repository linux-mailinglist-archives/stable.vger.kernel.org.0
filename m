Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662BA200F61
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404148AbgFSPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404132AbgFSPRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:17:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD4F2158C;
        Fri, 19 Jun 2020 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579828;
        bh=ekLNBpf31GOaE6htK8WXnUBTXk1rra0US7N5JT8qH1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfqjr4xpyqg2d3LoUriaBMULknDNfuRzVU9cmvqo8qz13UVf5vzASy+mIXm6LfYJD
         CpUjObWzLiD7YPxtMZc/eaCCid/O5vwlgXR5zhsfdsu+QPzp2MDrv/kQbT7p5fPA6w
         pdBBBAtzXmVzwgvcTStOIOLUgGI2aS2D0SavhiI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 009/376] scripts: sphinx-pre-install: address some issues with Gentoo
Date:   Fri, 19 Jun 2020 16:28:47 +0200
Message-Id: <20200619141710.804730523@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit e45a631742fadd7c9feb5a0049382102e5d43fe7 ]

There are some small misdetections with Gentoo. While they
don't cause too much trouble, it keeps recomending to
install things that are already there.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Link: https://lore.kernel.org/r/7f631edce102b02ccbdbfb18be1376a86b41373d.1586883286.git.mchehab+huawei@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index fa3fb05cd54b..09b38ee38ce8 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -557,7 +557,8 @@ sub give_gentoo_hints()
 			   "media-fonts/dejavu", 2) if ($pdf);
 
 	if ($pdf) {
-		check_missing_file(["/usr/share/fonts/noto-cjk/NotoSansCJKsc-Regular.otf"],
+		check_missing_file(["/usr/share/fonts/noto-cjk/NotoSansCJKsc-Regular.otf",
+				    "/usr/share/fonts/noto-cjk/NotoSerifCJK-Regular.ttc"],
 				   "media-fonts/noto-cjk", 2);
 	}
 
@@ -572,10 +573,10 @@ sub give_gentoo_hints()
 	my $portage_imagemagick = "/etc/portage/package.use/imagemagick";
 	my $portage_cairo = "/etc/portage/package.use/graphviz";
 
-	if (qx(cat $portage_imagemagick) ne "$imagemagick\n") {
+	if (qx(grep imagemagick $portage_imagemagick 2>/dev/null) eq "") {
 		printf("\tsudo su -c 'echo \"$imagemagick\" > $portage_imagemagick'\n")
 	}
-	if (qx(cat $portage_cairo) ne  "$cairo\n") {
+	if (qx(grep graphviz $portage_cairo 2>/dev/null) eq  "") {
 		printf("\tsudo su -c 'echo \"$cairo\" > $portage_cairo'\n");
 	}
 
-- 
2.25.1



