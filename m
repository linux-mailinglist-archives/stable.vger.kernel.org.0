Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2690B157A46
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgBJNVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgBJMh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:29 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83F7A24671;
        Mon, 10 Feb 2020 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338248;
        bh=Ass9Qglo5YTankLhHR3RLmxch4QTiOoSFpOhVzRIISk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gc52uEmNmGGGIAXHK3KzTzonnThmG3xHOg6VTeYNCIdkw0YXVoqQIFPLc75mW62/q
         KzyKEQEPHfxWAmVYIOgbRvPsz4TC2kIT9NbDRisqyi5DEmz0dnDIPrhzsd9Kh2PkVt
         Wr3zEImdxtEJI/BnF5wjnICTrQ6ZNc5LVvmKq3vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.4 109/309] scripts/find-unused-docs: Fix massive false positives
Date:   Mon, 10 Feb 2020 04:31:05 -0800
Message-Id: <20200210122417.125536808@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 1630146db2111412e7524d05d812ff8f2c75977e upstream.

scripts/find-unused-docs.sh invokes scripts/kernel-doc to find out if a
source file contains kerneldoc or not.

However, as it passes the no longer supported "-text" option to
scripts/kernel-doc, the latter prints out its help text, causing all
files to be considered containing kerneldoc.

Get rid of these false positives by removing the no longer supported
"-text" option from the scripts/kernel-doc invocation.

Cc: stable@vger.kernel.org  # 4.16+
Fixes: b05142675310d2ac ("scripts: kernel-doc: get rid of unused output formats")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20200127093107.26401-1-geert+renesas@glider.be
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/find-unused-docs.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/find-unused-docs.sh
+++ b/scripts/find-unused-docs.sh
@@ -54,7 +54,7 @@ for file in `find $1 -name '*.c'`; do
 	if [[ ${FILES_INCLUDED[$file]+_} ]]; then
 	continue;
 	fi
-	str=$(scripts/kernel-doc -text -export "$file" 2>/dev/null)
+	str=$(scripts/kernel-doc -export "$file" 2>/dev/null)
 	if [[ -n "$str" ]]; then
 	echo "$file"
 	fi


