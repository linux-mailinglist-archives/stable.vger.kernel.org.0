Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB6445BFD3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345748AbhKXNCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345741AbhKXNAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756F160E94;
        Wed, 24 Nov 2021 12:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757268;
        bh=dNrSxTnoCVLLjsQAZc8rgxLxELIajzBjpIq6pIbRNM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GcE+8MqfzHnl7FEl1v4NiUAxB4KXnz5/5Lip0tWw45876XbWzoL1H5KRaYQUpFcK
         XZBQZQjruB+pODX6f/2JKeM+KN/QtDzY0NCHahcjpsr3ej7lIWz4rygXlyTFXjd+SB
         N1DNwMRr5GusAIpgrT+TVdRtXCA99Mg9FDflHN5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lasse Collin <lasse.collin@tukaani.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/323] lib/xz: Validate the value before assigning it to an enum variable
Date:   Wed, 24 Nov 2021 12:55:01 +0100
Message-Id: <20211124115722.707390857@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index bd1d182419d7e..0b161f90d8d80 100644
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



