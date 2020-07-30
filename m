Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07022232D62
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgG3IKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbgG3IKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D1020838;
        Thu, 30 Jul 2020 08:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096602;
        bh=w60tyvXLW9cNr4285M8aqInRux1P5nqyWnXgRzOAkmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayvAM2qxowx+oeUdvA89vMiOQcG9RpczYz7ew1XYuHRXcm+jF7ljkcjBIc+YhFj7i
         NjljycYUwJ6tICAJO2KmP9zEqMPEkTZu7nmjVCrue4oIKboDuIF5zH2Pjsfl6jpX2R
         +UylJY4X4KakcRhsgGfBLiq1mHViBorvrZxrtXWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Shik Chen <shik@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 20/61] scripts/decode_stacktrace: strip basepath from all paths
Date:   Thu, 30 Jul 2020 10:04:38 +0200
Message-Id: <20200730074421.829350002@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit d178770d8d21489abf5bafefcbb6d5243b482e9a ]

Currently the basepath is removed only from the beginning of the string.
When the symbol is inlined and there's multiple line outputs of
addr2line, only the first line would have basepath removed.

Change to remove the basepath prefix from all lines.

Fixes: 31013836a71e ("scripts/decode_stacktrace: match basepath using shell prefix operator, not regex")
Co-developed-by: Shik Chen <shik@chromium.org>
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Shik Chen <shik@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Link: http://lkml.kernel.org/r/20200720082709.252805-1-pihsun@chromium.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 98cf6343afcd7..61564e56e3aa3 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -76,8 +76,8 @@ parse_symbol() {
 		return
 	fi
 
-	# Strip out the base of the path
-	code=${code#$basepath/}
+	# Strip out the base of the path on each line
+	code=$(while read -r line; do echo "${line#$basepath/}"; done <<< "$code")
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
-- 
2.25.1



