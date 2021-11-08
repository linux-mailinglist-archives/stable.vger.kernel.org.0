Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F80044A290
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbhKIBT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243138AbhKIBPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41EB161452;
        Tue,  9 Nov 2021 01:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419972;
        bh=dNrSxTnoCVLLjsQAZc8rgxLxELIajzBjpIq6pIbRNM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON/NuXMHb0fss4WVKTS0Ww6UgJV4cYPNJnY++RZel6edazd4u3SbZtcN2asDRQ/5Q
         jeM7slFbaRG9M5e8v8wiaYvkQcrXdGb2hjV8eQUmL+CyhsidozHt+57TK2PLPUEaI0
         IXd47iJ5JU/z7DziK07EgStdOlDzxrkswlQvqTDmJeahHpWG749tfZxzhIxsfN2Xs8
         C2pKnI2CwAVf25JySks0XTje5aInmEFT3CxIY9RKYANQsUzERm3J2rSVGDtrssmCbi
         TSC6ItTgCr4P+wz8gqy1UR/Uf2Gr4IZaMMjuDBhNb2gJvFEk87tet6AjGZomGW7LW8
         WH3YgKHNRgkiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lasse Collin <lasse.collin@tukaani.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>, gustavoars@kernel.org,
        ojeda@kernel.org, nathan@kernel.org, ndesaulniers@google.com
Subject: [PATCH AUTOSEL 4.19 31/47] lib/xz: Validate the value before assigning it to an enum variable
Date:   Mon,  8 Nov 2021 12:50:15 -0500
Message-Id: <20211108175031.1190422-31-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

