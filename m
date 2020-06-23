Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28756205D55
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388912AbgFWUMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388924AbgFWUMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CC4206C3;
        Tue, 23 Jun 2020 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943120;
        bh=G5GnVQz8QaMHJqYu9A89J1iR3ueOD57gBZUxL7V3hS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fajHanvb0xTLtHU2AYXOmrPAW49sB4BHnNOQXCfGXLjl0hH6L1fMuKGVI8QUMWBvL
         sc9TenLnwIvIkuq6+DJem6wBO+0bnP28RcuxCvl++x6lzAw1r7K256jtBul3VnVa5Z
         z+HnlvU5FcArj2vYwBcD2rXDOauZgG/nHD4lZIno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siddharth Gupta <sidgup@codeaurora.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 266/477] scripts: headers_install: Exit with error on config leak
Date:   Tue, 23 Jun 2020 21:54:23 +0200
Message-Id: <20200623195420.144091889@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddharth Gupta <sidgup@codeaurora.org>

[ Upstream commit 5967577231f9b19acd5a59485e9075964065bbe3 ]

Misuse of CONFIG_* in UAPI headers should result in an error. These config
options can be set in userspace by the user application which includes
these headers to control the APIs and structures being used in a kernel
which supports multiple targets.

Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/headers_install.sh | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index a07668a5c36b1..94a833597a884 100755
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -64,7 +64,7 @@ configs=$(sed -e '
 	d
 ' $OUTFILE)
 
-# The entries in the following list are not warned.
+# The entries in the following list do not result in an error.
 # Please do not add a new entry. This list is only for existing ones.
 # The list will be reduced gradually, and deleted eventually. (hopefully)
 #
@@ -98,18 +98,19 @@ include/uapi/linux/raw.h:CONFIG_MAX_RAW_DEVS
 
 for c in $configs
 do
-	warn=1
+	leak_error=1
 
 	for ignore in $config_leak_ignores
 	do
 		if echo "$INFILE:$c" | grep -q "$ignore$"; then
-			warn=
+			leak_error=
 			break
 		fi
 	done
 
-	if [ "$warn" = 1 ]; then
-		echo "warning: $INFILE: leak $c to user-space" >&2
+	if [ "$leak_error" = 1 ]; then
+		echo "error: $INFILE: leak $c to user-space" >&2
+		exit 1
 	fi
 done
 
-- 
2.25.1



