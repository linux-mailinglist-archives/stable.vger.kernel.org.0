Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1984491D7E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245618AbiARDhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353203AbiARDek (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:34:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55550C02B751;
        Mon, 17 Jan 2022 18:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAEAE6130B;
        Tue, 18 Jan 2022 02:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68211C36AF3;
        Tue, 18 Jan 2022 02:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473865;
        bh=EFtw07ghmDhsLRYEMt7OcljBkB5I335EQOUAD3LHu60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hS7FHgnQp6Bv90KyG2+5MyQBrfl7Zb0kUxf8e2aErVI744szuVlr/SP0YSiyaUdRl
         eDWaIJlLqocaHXB1QllXmVa2Kgao1IqiLpcYQ3xLkyDs384r3eFY8FD+qr9kSAVkwr
         B4b0ad+boQDhprNh/eSN8IrXq+H01b/b7qdgzteVnxcLbPBvwjcx4LPyxD89TKk6TS
         ZTCijMCu381oxAEywZ9wmb9Ez4WZxSfvmafMbQ5QxPHYqCHnQGCDxSns3Vl5HF9Owk
         lTS9g1kQjHAgWCWUbw26lmXW6XUCAyzh2SHvXwY7h8nJpWqPmvyeYYPEue2LBiouiy
         Xd4dxZaez4Usw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 114/116] scripts: sphinx-pre-install: Fix ctex support on Debian
Date:   Mon, 17 Jan 2022 21:40:05 -0500
Message-Id: <20220118024007.1950576-114-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

