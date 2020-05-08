Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2B1CAC1A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgEHMuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgEHMuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9627824959;
        Fri,  8 May 2020 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942203;
        bh=rqwiKhf2BLURmX6eRQeZLiO0HnJNekfAjN4i7IDcxOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loeeIAbV8YHte5Vpx0WzW31SxXu8McpFNK8cW6Lk8oPKtGf8RGk8Cof197xmmbhrV
         53Wngw3EPeau6T0hfiSOk88CPCAlH1+TiIzeWm6tYdMFPgw32h7B5BioTZBFTYEtPQ
         WENCzZMaZDPTpvIDWHrA3QQJf4/ORg143Py7s5ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Jeremie Francois (on alpha)" <jeremie.francois@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/18] scripts/config: allow colons in option strings for sed
Date:   Fri,  8 May 2020 14:35:12 +0200
Message-Id: <20200508123032.959347035@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
References: <20200508123030.497793118@linuxfoundation.org>
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
index 026aeb4f32ee3..73de17d396987 100755
--- a/scripts/config
+++ b/scripts/config
@@ -6,6 +6,9 @@ myname=${0##*/}
 # If no prefix forced, use the default CONFIG_
 CONFIG_="${CONFIG_-CONFIG_}"
 
+# We use an uncommon delimiter for sed substitutions
+SED_DELIM=$(echo -en "\001")
+
 usage() {
 	cat >&2 <<EOL
 Manipulate options in a .config file from the command line.
@@ -82,7 +85,7 @@ txt_subst() {
 	local infile="$3"
 	local tmpfile="$infile.swp"
 
-	sed -e "s:$before:$after:" "$infile" >"$tmpfile"
+	sed -e "s$SED_DELIM$before$SED_DELIM$after$SED_DELIM" "$infile" >"$tmpfile"
 	# replace original file with the edited one
 	mv "$tmpfile" "$infile"
 }
-- 
2.20.1



