Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6086137FF2
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgAKKYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbgAKKYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:24:20 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D454205F4;
        Sat, 11 Jan 2020 10:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738260;
        bh=tNIxl4x5EyhwWirr1G7H/6k1XgznDwSrGldniwcZWT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBkKDlAu5NJutx3Bk9T99Y+MwXx8NrOCumBv5Mb0uni6alFBxMVTSskiuRJkF+OM+
         2mgGkmu4zYSEnnLfaHf+ZOky+1UD5tAQ1GzyouoYy7PpqQ786SEEGp78mh9N4MGBYE
         nPEbfIBDzq8Jj6cny4/EWmcxCyn78lwKmazWobcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/165] kselftest: Support old perl versions
Date:   Sat, 11 Jan 2020 10:49:40 +0100
Message-Id: <20200111094926.272746866@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit 4eac734486fd431e0756cc5e929f140911a36a53 ]

On an old perl such as v5.10.1, `kselftest/prefix.pl` gives below error
message:

    Can't locate object method "autoflush" via package "IO::Handle" at kselftest/prefix.pl line 10.

This commit fixes the error by explicitly specifying the use of the
`IO::Handle` package.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/prefix.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kselftest/prefix.pl b/tools/testing/selftests/kselftest/prefix.pl
index ec7e48118183..31f7c2a0a8bd 100755
--- a/tools/testing/selftests/kselftest/prefix.pl
+++ b/tools/testing/selftests/kselftest/prefix.pl
@@ -3,6 +3,7 @@
 # Prefix all lines with "# ", unbuffered. Command being piped in may need
 # to have unbuffering forced with "stdbuf -i0 -o0 -e0 $cmd".
 use strict;
+use IO::Handle;
 
 binmode STDIN;
 binmode STDOUT;
-- 
2.20.1



