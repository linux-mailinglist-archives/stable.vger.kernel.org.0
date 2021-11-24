Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67D645B9F5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhKXMGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242279AbhKXMFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B1861050;
        Wed, 24 Nov 2021 12:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755346;
        bh=zqqkFx/omr5n5IvJLSH3YWicnLaayEf/zl3DEO8ju6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oevUQG1+z7yQyk5szTp97XlIxe/2EuaFmIlFhxHhJXyAvCSAWTeSd8uhvBt3kjxZL
         I18ucnuD73MTEltONH63HVfrgmZer6Oi+1mMNJAgOgk2+wBUuMQE/pxCDWosxUxXuu
         Ml6NWgZDLJhpViFHVILuRRaKzHlMwkw+pepTNULI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lasse Collin <lasse.collin@tukaani.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 062/162] lib/xz: Validate the value before assigning it to an enum variable
Date:   Wed, 24 Nov 2021 12:56:05 +0100
Message-Id: <20211124115700.336835398@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

[ Upstream commit 4f8d7abaa413c34da9d751289849dbfb7c977d05 ]

This might matter, for example, if the underlying type of enum xz_check
was a signed char. In such a case the validation wouldn't have caught an
unsupported header. I don't know if this problem can occur in the kernel
on any arch but it's still good to fix it because some people might copy
the XZ code to their own projects from Linux instead of the upstream
XZ Embedded repository.

This change may increase the code size by a few bytes. An alternative
would have been to use an unsigned int instead of enum xz_check but
using an enumeration looks cleaner.

Link: https://lore.kernel.org/r/20211010213145.17462-3-xiang@kernel.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/xz/xz_dec_stream.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/xz/xz_dec_stream.c b/lib/xz/xz_dec_stream.c
index ac809b1e64f78..9e5b9ab537fea 100644
--- a/lib/xz/xz_dec_stream.c
+++ b/lib/xz/xz_dec_stream.c
@@ -402,12 +402,12 @@ static enum xz_ret dec_stream_header(struct xz_dec *s)
 	 * we will accept other check types too, but then the check won't
 	 * be verified and a warning (XZ_UNSUPPORTED_CHECK) will be given.
 	 */
+	if (s->temp.buf[HEADER_MAGIC_SIZE + 1] > XZ_CHECK_MAX)
+		return XZ_OPTIONS_ERROR;
+
 	s->check_type = s->temp.buf[HEADER_MAGIC_SIZE + 1];
 
 #ifdef XZ_DEC_ANY_CHECK
-	if (s->check_type > XZ_CHECK_MAX)
-		return XZ_OPTIONS_ERROR;
-
 	if (s->check_type > XZ_CHECK_CRC32)
 		return XZ_UNSUPPORTED_CHECK;
 #else
-- 
2.33.0



