Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB51F221F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgFHXGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgFHXGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542A62076C;
        Mon,  8 Jun 2020 23:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657582;
        bh=ekLNBpf31GOaE6htK8WXnUBTXk1rra0US7N5JT8qH1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWLB2XNor0QD5ecdltAZx7PD4+VcjUso70MyfMsYbGvpUPxuDZOzmPiBxGleCp6fA
         mxgL1jeaclDhL/PqafVFNAQ4mQCKHKT45NxHEokuantZg8/y6Q9osDsgQjWwzercEg
         E0qsnVQblnoArnFfEN+Lrf947e4HKKsTu96yf+Uo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 011/274] scripts: sphinx-pre-install: address some issues with Gentoo
Date:   Mon,  8 Jun 2020 19:01:44 -0400
Message-Id: <20200608230607.3361041-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

