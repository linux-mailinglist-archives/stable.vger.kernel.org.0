Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C42D607F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391190AbgLJOjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391182AbgLJOi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Wise <pabs3@bonedaddy.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Wilk <jwilk@jwilk.net>
Subject: [PATCH 5.9 52/75] coredump: fix core_pattern parse error
Date:   Thu, 10 Dec 2020 15:27:17 +0100
Message-Id: <20201210142608.627125476@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

commit 2bf509d96d84c3336d08375e8af34d1b85ee71c8 upstream.

'format_corename()' will splite 'core_pattern' on spaces when it is in
pipe mode, and take helper_argv[0] as the path to usermode executable.
It works fine in most cases.

However, if there is a space between '|' and '/file/path', such as
'| /usr/lib/systemd/systemd-coredump %P %u %g', then helper_argv[0] will
be parsed as '', and users will get a 'Core dump to | disabled'.

It is not friendly to users, as the pattern above was valid previously.
Fix this by ignoring the spaces between '|' and '/file/path'.

Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -229,7 +229,8 @@ static int format_corename(struct core_n
 		 */
 		if (ispipe) {
 			if (isspace(*pat_ptr)) {
-				was_space = true;
+				if (cn->used != 0)
+					was_space = true;
 				pat_ptr++;
 				continue;
 			} else if (was_space) {


