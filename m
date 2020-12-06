Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4542D0125
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 07:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgLFGPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 01:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 01:15:23 -0500
Date:   Sat, 05 Dec 2020 22:14:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235283;
        bh=FK5p77zY63eqh74pQFA4qHfdP6Wbip7SX+nT8OBcPO8=;
        h=From:To:Subject:In-Reply-To:From;
        b=n43jEqr6qJo6AXwpjo2BwFmCs4zQ77NBczXlG792lH1j57vcw7UoXJP1dp2T+eeIK
         99GhcJvDxpyZDpxe/C4eqK+xEe5Q+W8+VT69xET14I1qJC3MZqSznpuYZmH6rEvsGA
         DC05RKDo8qLVezr38YedMN6y79jLqmB0GJnnGin8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dong.menglong@zte.com.cn,
        jwilk@jwilk.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nhorman@tuxdriver.com, pabs3@bonedaddy.net, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/12] coredump: fix core_pattern parse error
Message-ID: <20201206061442.va_wmK_ha%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>
Subject: coredump: fix core_pattern parse error

'format_corename()' will splite 'core_pattern' on spaces when it is in
pipe mode, and take helper_argv[0] as the path to usermode executable.

It works fine in most cases. However, if there is a space between
'|' and '/file/path', such as
'| /usr/lib/systemd/systemd-coredump %P %u %g',
helper_argv[0] will be parsed as '', and users will get a
'Core dump to | disabled'.

It is not friendly to users, as the pattern above was valid previously. 
Fix this by ignoring the spaces between '|' and '/file/path'.

Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coredump.c~coredump-fix-core_pattern-parse-error
+++ a/fs/coredump.c
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
_
