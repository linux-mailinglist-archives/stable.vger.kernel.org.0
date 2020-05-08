Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD981CAD2B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgEHMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730022AbgEHMxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:53:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD1424953;
        Fri,  8 May 2020 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942384;
        bh=gwwltBoEbues8SEU545brQ4mqhSyAnYy0hmSd/ji+j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic6aVHO3xBdFELvvmx641J0IFtODHTrFqk0mEveDZ9Vjoa/29EvY7Ulv63a4F2ivt
         cLOAXqLFVZ6GRje9PXr0RH8T0xqjOJ/esu921CQbxhXsnGqpApN/49k9OJnQIu8gHO
         cJ3pZ+gT54bxwH6d/OAIspjX2j/Yb4+3ZQgJ5790=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Jeremie Francois (on alpha)" <jeremie.francois@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/50] scripts/config: allow colons in option strings for sed
Date:   Fri,  8 May 2020 14:35:29 +0200
Message-Id: <20200508123046.630074353@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremie Francois (on alpha) <jeremie.francois@gmail.com>

[ Upstream commit e461bc9f9ab105637b86065d24b0b83f182d477c ]

Sed broke on some strings as it used colon as a separator.
I made it more robust by using \001, which is legit POSIX AFAIK.

E.g. ./config --set-str CONFIG_USBNET_DEVADDR "de:ad:be:ef:00:01"
failed with: sed: -e expression #1, char 55: unknown option to `s'

Signed-off-by: Jeremie Francois (on alpha) <jeremie.francois@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/config | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/config b/scripts/config
index e0e39826dae90..eee5b7f3a092a 100755
--- a/scripts/config
+++ b/scripts/config
@@ -7,6 +7,9 @@ myname=${0##*/}
 # If no prefix forced, use the default CONFIG_
 CONFIG_="${CONFIG_-CONFIG_}"
 
+# We use an uncommon delimiter for sed substitutions
+SED_DELIM=$(echo -en "\001")
+
 usage() {
 	cat >&2 <<EOL
 Manipulate options in a .config file from the command line.
@@ -83,7 +86,7 @@ txt_subst() {
 	local infile="$3"
 	local tmpfile="$infile.swp"
 
-	sed -e "s:$before:$after:" "$infile" >"$tmpfile"
+	sed -e "s$SED_DELIM$before$SED_DELIM$after$SED_DELIM" "$infile" >"$tmpfile"
 	# replace original file with the edited one
 	mv "$tmpfile" "$infile"
 }
-- 
2.20.1



