Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1CE49913E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378890AbiAXUKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53818 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376365AbiAXUBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BBA6090A;
        Mon, 24 Jan 2022 20:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A387BC340E7;
        Mon, 24 Jan 2022 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054491;
        bh=EFtw07ghmDhsLRYEMt7OcljBkB5I335EQOUAD3LHu60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsD+kffF935WcsvN4opJTo5kY7Vwq+j0n1pGHfLcSCs9ctifKKTbOVmrP/Av0EsYm
         jaDUwIe/RjJwFrp4WyP5M0I77a9ou+55a9sIfQ3Uxf+VhAk9LqyPXexH+OLmZb6C2K
         IIS1AvdgGJnK/AgTw0hQyOSEnTm0k1Wg/vz/oVE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 407/563] scripts: sphinx-pre-install: Fix ctex support on Debian
Date:   Mon, 24 Jan 2022 19:42:52 +0100
Message-Id: <20220124184038.518662343@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]

The name of the package with ctexhook.sty is different on
Debian/Ubuntu.

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 828a8615a9181..b32a20782c851 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -370,6 +370,9 @@ sub give_debian_hints()
 	);
 
 	if ($pdf) {
+		check_missing_file(["/usr/share/texlive/texmf-dist/tex/latex/ctex/ctexhook.sty"],
+				   "texlive-lang-chinese", 2);
+
 		check_missing_file(["/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"],
 				   "fonts-dejavu", 2);
 
-- 
2.34.1



